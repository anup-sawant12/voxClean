import os
import sys
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
)
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super().showPage()
        super().save()
        print(f"Total pages generated: {num_pages}")


    def draw_page_decorations(self, total_pages):
        w, h = A4
        self.saveState()
        # Top subtle accent bar
        self.setFillColor(colors.HexColor("#1E3A8A")) # Deep Navy
        self.rect(0, h - 5, w, 5, fill=True, stroke=False)
        
        # Bottom footer bar
        self.setStrokeColor(colors.HexColor("#CBD5E1"))
        self.setLineWidth(0.6)
        self.line(28, 20, w - 28, 20)
        
        # Footer text
        self.setFont("Helvetica", 7.2)
        self.setFillColor(colors.HexColor("#64748B"))
        self.drawString(28, 10, "VoxClean AI • Project Proposal & Technical Specification")
        self.drawRightString(w - 28, 10, f"Page {self._pageNumber} of {total_pages} • MATLAB R2022a+ Framework")
        self.restoreState()


def create_proposal_pdf(output_path="VoxClean_AI_Project_Proposal.pdf"):
    doc = SimpleDocTemplate(
        output_path,
        pagesize=A4,
        leftMargin=26,
        rightMargin=26,
        topMargin=20,
        bottomMargin=24
    )

    styles = getSampleStyleSheet()
    
    # Custom Palette
    NAVY = colors.HexColor("#0F172A")
    PRIMARY_BLUE = colors.HexColor("#1E40AF")
    TEAL_ACCENT = colors.HexColor("#0284C7")
    DARK_GRAY = colors.HexColor("#1E293B")
    MUTED_GRAY = colors.HexColor("#475569")
    LIGHT_BG = colors.HexColor("#F8FAFC")
    BORDER_COLOR = colors.HexColor("#CBD5E1")
    WHITE = colors.white

    # Custom typography styles
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=13.5,
        leading=16.5,
        textColor=WHITE
    )
    
    subtitle_style = ParagraphStyle(
        'DocSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.0,
        leading=10.5,
        textColor=colors.HexColor("#E0E7FF")
    )

    sec_header_style = ParagraphStyle(
        'SecHeader',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=8.2,
        leading=10.5,
        textColor=PRIMARY_BLUE
    )

    body_style = ParagraphStyle(
        'Body',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=6.9,
        leading=9.0,
        textColor=DARK_GRAY
    )

    body_bold = ParagraphStyle(
        'BodyBold',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=6.9,
        leading=9.0,
        textColor=DARK_GRAY
    )

    bullet_style = ParagraphStyle(
        'Bullet',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=6.7,
        leading=8.6,
        textColor=DARK_GRAY,
        leftIndent=6
    )

    table_header = ParagraphStyle(
        'TableHeader',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=6.5,
        leading=8.0,
        textColor=WHITE,
        alignment=1
    )

    table_cell = ParagraphStyle(
        'TableCell',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=6.4,
        leading=7.8,
        textColor=DARK_GRAY
    )

    table_cell_center = ParagraphStyle(
        'TableCellCenter',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=6.4,
        leading=7.8,
        textColor=DARK_GRAY,
        alignment=1
    )

    table_cell_bold = ParagraphStyle(
        'TableCellBold',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=6.4,
        leading=7.8,
        textColor=DARK_GRAY
    )

    story = []

    # 1. HEADER BANNER
    header_content = [
        [
            Paragraph("PROJECT PROPOSAL: VOXCLEAN AI", title_style),
            Paragraph("OCTOBER 2026<br/><font color='#CBD5E1'>PROPOSAL ID: VC-2026-01</font>", ParagraphStyle(
                'HeaderRight', parent=styles['Normal'], fontName='Helvetica-Bold', fontSize=7.2, leading=9.5, textColor=WHITE, alignment=2
            ))
        ],
        [
            Paragraph("Deep Learning & DSP-Driven Speech Enhancement and Background Noise Suppression System", subtitle_style),
            Paragraph("MATLAB R2022a+ • Deep Learning, Audio & Signal Processing Toolboxes", ParagraphStyle(
                'HeaderRightSub', parent=styles['Normal'], fontName='Helvetica', fontSize=6.8, leading=9.0, textColor=colors.HexColor("#BAE6FD"), alignment=2
            ))
        ]
    ]

    header_table = Table(header_content, colWidths=[385, 158])
    header_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), PRIMARY_BLUE),
        ('PADDING', (0,0), (-1,-1), 5),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    story.append(header_table)
    story.append(Spacer(1, 3.5))

    # 2. EXECUTIVE SUMMARY & PROBLEM STATEMENT (Two Columns)
    sec1_left = [
        Paragraph("1. EXECUTIVE SUMMARY", sec_header_style),
        Spacer(1, 1),
        Paragraph(
            "<b>VoxClean AI</b> is an engineering framework integrating classical Digital Signal Processing (DSP) with Deep Convolutional Neural Networks for acoustic speech enhancement. The project's core objective is single-channel background noise suppression to isolate target speech corrupted by non-stationary real-world noise (traffic, typing, domestic noise, restaurant babble). Operating in the Time-Frequency domain via Short-Time Fourier Transform (STFT), it synthesizes artifact-free, high-intelligibility speech.",
            body_style
        )
    ]

    sec1_right = [
        Paragraph("2. PROBLEM STATEMENT & MOTIVATION", sec_header_style),
        Spacer(1, 1),
        Paragraph(
            "Environmental acoustic noise severely degrades intelligibility in telecommunications, hearing aids, voice assistants, and conference systems. Traditional DSP filters (e.g., spectral subtraction, Wiener filtering) suffer from 'musical noise' artifacts and phonetic distortion under dynamic non-stationary conditions. Conversely, raw time-domain deep networks are computationally prohibitive. VoxClean AI resolves this trade-off via a lightweight, high-precision Time-Frequency masking paradigm.",
            body_style
        )
    ]

    sec1_table = Table([[sec1_left, sec1_right]], colWidths=[268, 275])
    sec1_table.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('LEFTPADDING', (0,0), (-1,-1), 0),
        ('RIGHTPADDING', (0,0), (-1,-1), 4),
        ('TOPPADDING', (0,0), (-1,-1), 1),
        ('BOTTOMPADDING', (0,0), (-1,-1), 1),
    ]))
    story.append(sec1_table)
    story.append(Spacer(1, 3.5))

    # 3. TECHNICAL ARCHITECTURE & MATHEMATICAL FORMULATION
    story.append(Paragraph("3. TECHNICAL ARCHITECTURE & DSP PIPELINE", sec_header_style))
    story.append(Spacer(1, 1.5))

    p1 = [
        Paragraph("<b>Stage A: DSP Front-End</b>", body_bold),
        Paragraph("• Standardized <b>16 kHz Mono</b> (Nyquist = 8 kHz)<br/>• 512-pt <b>Hann Window</b>, 50% overlap (256 hop)<br/>• STFT matrix: <b>257 bins × 126 frames</b> (2.0s audio)<br/>• Decouples Magnitude |Y(t,f)| & Phase ∠Y(t,f)", bullet_style)
    ]
    p2 = [
        Paragraph("<b>Stage B: 2D CNN Ratio Masking</b>", body_bold),
        Paragraph("• Target: <b>Ideal Ratio Mask (IRM)</b> ∈ [0, 1]<br/>• IRM(t,f) = |S(t,f)| / (|Y(t,f)| + ε), ε = 10⁻⁸<br/>• 4 Conv2D layers + BatchNorm + LeakyReLU (α=0.2)<br/>• Sigmoid output strictly constrains values to [0, 1]", bullet_style)
    ]
    p3 = [
        Paragraph("<b>Stage C: Waveform Synthesis</b>", body_bold),
        Paragraph("• Hadamard Masking: |Ŝ(t,f)| = M̂(t,f) ⊙ |Y(t,f)|<br/>• Complex Spectrum: Ŝ(t,f) = |Ŝ(t,f)| · e^(j·∠Y(t,f))<br/>• <b>iSTFT with Overlap-Add (OLA)</b> synthesis<br/>• Zero musical artifacts, natural harmonic recovery", bullet_style)
    ]

    pipeline_table = Table([[p1, p2, p3]], colWidths=[178, 186, 179])
    pipeline_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), LIGHT_BG),
        ('BOX', (0,0), (-1,-1), 0.5, BORDER_COLOR),
        ('INNERGRID', (0,0), (-1,-1), 0.4, BORDER_COLOR),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('PADDING', (0,0), (-1,-1), 3.5),
    ]))
    story.append(pipeline_table)
    story.append(Spacer(1, 3.5))

    # 4. CNN SPECIFICATION & DELIVERABLES (Two Columns)
    sec4_left = [
        Paragraph("4. NEURAL NETWORK SPECIFICATION", sec_header_style),
        Spacer(1, 1),
        Paragraph(
            "A 2D Convolutional regression network mapping input magnitude spectrograms [257 × 126 × 1] to estimated ratio masks.",
            body_style
        ),
        Spacer(1, 1.5),
        Table([
            [Paragraph("Layer", table_header), Paragraph("Kernel & Filters", table_header), Paragraph("Activation", table_header), Paragraph("Output Dim", table_header)],
            [Paragraph("Input", table_cell_bold), Paragraph("Noisy Magnitude", table_cell), Paragraph("None", table_cell), Paragraph("257×126×1", table_cell_center)],
            [Paragraph("Conv 1", table_cell_bold), Paragraph("3×3 Conv, 16 filters", table_cell), Paragraph("BN + LeakyReLU (0.2)", table_cell), Paragraph("257×126×16", table_cell_center)],
            [Paragraph("Conv 2", table_cell_bold), Paragraph("3×3 Conv, 32 filters", table_cell), Paragraph("BN + LeakyReLU (0.2)", table_cell), Paragraph("257×126×32", table_cell_center)],
            [Paragraph("Conv 3", table_cell_bold), Paragraph("3×3 Conv, 16 filters", table_cell), Paragraph("BN + LeakyReLU (0.2)", table_cell), Paragraph("257×126×16", table_cell_center)],
            [Paragraph("Conv 4", table_cell_bold), Paragraph("3×3 Conv, 1 filter", table_cell), Paragraph("Sigmoid Activation", table_cell), Paragraph("257×126×1 (IRM)", table_cell_center)],
        ], colWidths=[40, 94, 82, 50], style=[
            ('BACKGROUND', (0,0), (-1,0), PRIMARY_BLUE),
            ('BOX', (0,0), (-1,-1), 0.5, BORDER_COLOR),
            ('INNERGRID', (0,0), (-1,-1), 0.3, BORDER_COLOR),
            ('PADDING', (0,0), (-1,-1), 1.8),
            ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ]),
        Spacer(1, 1.5),
        Paragraph("<b>Training Regime:</b> Adam Optimizer (η = 10⁻³), Mini-batch 16, Loss: Mean Squared Error (MSE) on predicted vs ideal mask.", body_style)
    ]

    sec4_right = [
        Paragraph("5. KEY PROJECT DELIVERABLES", sec_header_style),
        Spacer(1, 1),
        Paragraph("• <b>Interactive Desktop GUI (VoxCleanApp.m):</b> Professional MATLAB App Designer interface with real-time waveform inspection, spectrogram displays, one-click AI denoising, and instant A/B audio comparison playback.", bullet_style),
        Paragraph("• <b>Automated Data Generation Pipeline:</b> Dynamic clean speech and noise blend generator (mixAudioWithSNR.m) with calibrated Signal-to-Noise Ratio (-5 dB to +15 dB) and automatic non-clipping peak normalization.", bullet_style),
        Paragraph("• <b>Modular DSP Core Library:</b> Clean, documented MATLAB routines for computeSTFT, computeIdealRatioMask, enhanceSpeech, evaluateModel, and interactive Live Scripts for rapid research.", bullet_style),
        Paragraph("• <b>Pretrained Neural Checkpoint:</b> Exported trainedModel.mat enabling instant out-of-the-box enhancement without mandatory retraining.", bullet_style),
    ]

    sec4_table = Table([[sec4_left, sec4_right]], colWidths=[268, 275])
    sec4_table.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('LEFTPADDING', (0,0), (-1,-1), 0),
        ('RIGHTPADDING', (0,0), (-1,-1), 4),
        ('TOPPADDING', (0,0), (-1,-1), 1),
        ('BOTTOMPADDING', (0,0), (-1,-1), 1),
    ]))
    story.append(sec4_table)
    story.append(Spacer(1, 3.5))

    # 5. EVALUATION BENCHMARKS & ROADMAP TABLE
    story.append(Paragraph("6. PERFORMANCE EVALUATION TARGETS & IMPLEMENTATION ROADMAP", sec_header_style))
    story.append(Spacer(1, 1.5))

    eval_data = [
        [
            Paragraph("Metric", table_header),
            Paragraph("Target Spec", table_header),
            Paragraph("Technical Objective", table_header),
            Paragraph("Implementation Phase", table_header),
            Paragraph("Target Milestone / Deliverable", table_header)
        ],
        [
            Paragraph("<b>ΔSNR (dB)</b>", table_cell),
            Paragraph("+5 to +12 dB", table_cell_center),
            Paragraph("Acoustic noise power reduction", table_cell),
            Paragraph("<b>Phase 1: DSP Engine</b>", table_cell),
            Paragraph("STFT/iSTFT framing, Hann windowing, data pairing", table_cell)
        ],
        [
            Paragraph("<b>PESQ (P.862)</b>", table_cell),
            Paragraph("≥ 3.0 / 4.5", table_cell_center),
            Paragraph("Standard perceptual voice quality", table_cell),
            Paragraph("<b>Phase 2: CNN Training</b>", table_cell),
            Paragraph("2D ConvNet regression on IRM, MSE loss convergence", table_cell)
        ],
        [
            Paragraph("<b>STOI Score</b>", table_cell),
            Paragraph("≥ 0.85 / 1.0", table_cell_center),
            Paragraph("Speech envelope intelligibility preservation", table_cell),
            Paragraph("<b>Phase 3: GUI Application</b>", table_cell),
            Paragraph("MATLAB uifigure app, live spectrograms, playback", table_cell)
        ],
        [
            Paragraph("<b>Latency</b>", table_cell),
            Paragraph("< 0.4× Real-Time", table_cell_center),
            Paragraph("Efficient inference for edge streaming", table_cell),
            Paragraph("<b>Phase 4: Benchmarking</b>", table_cell),
            Paragraph("PESQ/STOI evaluation scripts, documentation, packaging", table_cell)
        ]
    ]

    eval_table = Table(eval_data, colWidths=[65, 65, 140, 100, 173])
    eval_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), PRIMARY_BLUE),
        ('BOX', (0,0), (-1,-1), 0.5, BORDER_COLOR),
        ('INNERGRID', (0,0), (-1,-1), 0.3, BORDER_COLOR),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [WHITE, LIGHT_BG]),
        ('PADDING', (0,0), (-1,-1), 1.8),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    story.append(eval_table)
    story.append(Spacer(1, 3.5))

    # 6. SIGN-OFF / CONCLUSION HIGHLIGHT BOX
    summary_box_content = [
        [
            Paragraph(
                "<b>Project Feasibility & Practical Impact:</b> VoxClean AI delivers an end-to-end, reproducible MATLAB solution for speech enhancement. By combining established acoustic DSP theorems (Nyquist sampling, COLA windowing, STFT phase preservation) with modern 2D deep learning, the framework provides robust noise suppression with a compact model footprint, suitable for academic evaluation, telecommunication headsets, VoIP apps, and edge voice devices.",
                ParagraphStyle('SumBox', parent=styles['Normal'], fontName='Helvetica', fontSize=6.6, leading=8.4, textColor=DARK_GRAY)
            ),
            Paragraph(
                "<b>Status:</b> Specification Approved<br/><b>Toolboxes:</b> Audio, DL, Signal Processing<br/><b>Lead:</b> Speech AI & DSP Engineering",
                ParagraphStyle('SumBoxRight', parent=styles['Normal'], fontName='Helvetica', fontSize=6.6, leading=8.4, textColor=PRIMARY_BLUE)
            )
        ]
    ]
    summary_table = Table(summary_box_content, colWidths=[400, 143])
    summary_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#EFF6FF")),
        ('BOX', (0,0), (-1,-1), 0.6, colors.HexColor("#93C5FD")),
        ('PADDING', (0,0), (-1,-1), 3.5),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    story.append(summary_table)

    # Build the document
    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"PDF successfully generated at: {output_path}")

if __name__ == "__main__":
    create_proposal_pdf()
