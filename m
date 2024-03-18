Return-Path: <io-uring+bounces-1093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F08D87E657
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 10:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68EDBB22134
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 09:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863A02D042;
	Mon, 18 Mar 2024 09:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kb3k8P4z"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860102D03D
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 09:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710755458; cv=none; b=l13QA/H/jv0DH09v2HB7sNhcZ/24s/ttKq95Dq1pIJsaCEmgrDSHj7X8pP+uLKVMhEt7K56c/61jjzE7EkINcR6J5OxUAT9ujMU+Hnsr4SFAxEeBrkyxB43DLAn+Uu1AmOdHOW2TsI72N9h2+K4n+zfzMXSup3gucCbwXbGTWeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710755458; c=relaxed/simple;
	bh=bgtZP40auWLHRaHBFMfwntOcB48KPUpu69mNLUDMeu0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=k1WwZ6XRYMCS9YN72mfnlsioXUxJytGzvDrhJcjBSH5MHm7GIl7AXq/hqQRpCWhv4IzelDV3cCkYJnRh+X5Fwpjq4H7bfVX1I/zbJ9I3PDHzJAqPUnIxaFtwQOoaj/2pujWjHuenF4lRckrgZ45US6e5IJqi+EXqeBaEk+d8mdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kb3k8P4z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710755455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=BxBOTIJDd3fLDMxEua46MqZY/u/asGFrn5t8INnEjqU=;
	b=Kb3k8P4zj46Z4Gtg7J29szX4ab5cKqpfPcTt8xHYVKPw7sS1VT2e1aiibF2WvbITuVjO4n
	uNDpi7NK6GA8ElxyuVmqjKoYRR0k8hztif2JqD29aLIMVC+Ne1aoGx8WZrG8QqC7Nziz9f
	14fQmJmnzKzqzkVPjQkqxusRRjkMA3U=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-81J9Wt7oP9SBchuepCs0zg-1; Mon, 18 Mar 2024 05:50:52 -0400
X-MC-Unique: 81J9Wt7oP9SBchuepCs0zg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1dd96cc4476so31910195ad.1
        for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 02:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710755451; x=1711360251;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BxBOTIJDd3fLDMxEua46MqZY/u/asGFrn5t8INnEjqU=;
        b=HnievwoI2TbUxRD3kQ8jU79h4sN8t+91OWd81B4227nw9TyJo1iQM2PTvD9nkq7/Zm
         puxaUfkEFuVO1bgCeyFn7PtK+wNLS8gQyyFQF0qVzg8ve4jschTRJp7XBHFz2wr4+xN5
         icTzs0E5/ZRzcvLguUQ7gwm8xxAqFqhlMdXeRu4J7rpiDWuOEfj8NpmYYhzo/7GXpNzj
         rv2CR7bUiQVZ79RXmNLtBWSkaMVQV1pOQ6MeRpbNvbLD8fuWdvhNMhTrjhSh5kLhDFdY
         YduwoWfZCMsnbSTFRMru7/oqVZaFHB7FM+u2Y1dx3bE/w6FXc9YziiR8hqK6KNMxHKYv
         QWzg==
X-Gm-Message-State: AOJu0Yyam62ircmtQH1/26QsoO9/zKo3B/1odVzh6AxrfWIOH+4JxV64
	LHPP7+93dUCYBJQvYM4/GeIR9EA0j6IlZ1O2TtOtuKqyvn2QAP4AyA+KF00IuF3tdy8p64T/53M
	TpxxbXOl9oBcJB8wRs00/VZvtWSt4A+Cq5JJG9H+vSPzsp400SBoYAKH89SpzYmuhbpwM/4XuQU
	bh5AN1ijk4rv6ma6C/v7yG8YaaDd+gGxa8YWMyo7aBGEGv
X-Received: by 2002:a17:902:ef91:b0:1dd:50f0:3e72 with SMTP id iz17-20020a170902ef9100b001dd50f03e72mr10525481plb.26.1710755451533;
        Mon, 18 Mar 2024 02:50:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEncIBZpuYDGeUdj6q6a2ZLHDo4OB74wfRpFlnIAEi9Okga2G7KFkYtTlmKRpEfcGlo81ExynzlqqkJ/2REJH8=
X-Received: by 2002:a17:902:ef91:b0:1dd:50f0:3e72 with SMTP id
 iz17-20020a170902ef9100b001dd50f03e72mr10525477plb.26.1710755451105; Mon, 18
 Mar 2024 02:50:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Changhui Zhong <czhong@redhat.com>
Date: Mon, 18 Mar 2024 17:50:40 +0800
Message-ID: <CAGVVp+WOLnr9Hxd10Xwa8YpJ=W5Re9csPCMtNF8Ux0_zbg0ktA@mail.gmail.com>
Subject: [bug report] Kernel panic - not syncing: Fatal hardware error!
To: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

found a kernel panic issue after add io_uring parameters to kernel
cmdline and then reboot,
please help check,

repo:https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
branch: master
commit HEAD:f6cef5f8c37f58a3bc95b3754c3ae98e086631ca

grubby --args='io_uring.enable=y' --update-kernel=/boot/vmlinuz-6.8.0+
grubby --args='sysctl.kernel.io_uring_disabled=0'
--update-kernel=/boot/vmlinuz-6.8.0+
reboot

dmesg log:
Rebooting.
[  320.186317] {1}[Hardware Error]: Hardware error from APEI Generic
Hardware Error Source: 5
[  320.186321] {1}[Hardware Error]: event severity: fatal
[  320.186324] {1}[Hardware Error]:  Error 0, type: fatal
[  320.186325] {1}[Hardware Error]:   section_type: PCIe error
[  320.186326] {1}[Hardware Error]:   port_type: 0, PCIe end point
[  320.186327] {1}[Hardware Error]:   version: 3.0
[  320.186328] {1}[Hardware Error]:   command: 0x0002, status: 0x0010
[  320.186330] {1}[Hardware Error]:   device_id: 0000:01:00.1
[  320.186331] {1}[Hardware Error]:   slot: 0
[  320.186331] {1}[Hardware Error]:   secondary_bus: 0x00
[  320.186332] {1}[Hardware Error]:   vendor_id: 0x14e4, device_id: 0x165f
[  320.186333] {1}[Hardware Error]:   class_code: 020000
[  320.186334] {1}[Hardware Error]:   aer_uncor_status: 0x00100000,
aer_uncor_mask: 0x00010000
[  320.186335] {1}[Hardware Error]:   aer_uncor_severity: 0x000ef030
[  320.186336] {1}[Hardware Error]:   TLP Header: 40000001 0000030f
90028090 00000000
[  320.186339] Kernel panic - not syncing: Fatal hardware error!
[  320.186340] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.8.0+ #1
[  320.186343] Hardware name: Dell Inc. PowerEdge R640/0X45NX, BIOS
2.19.1 06/04/2023
[  320.186343] Call Trace:
[  320.186345]  <NMI>
[  320.186347]  panic+0x32b/0x350
[  320.186355]  __ghes_panic+0x69/0x70
[  320.186360]  ghes_in_nmi_queue_one_entry.constprop.0+0x1d9/0x2b0
[  320.186364]  ghes_notify_nmi+0x59/0xd0
[  320.186367]  nmi_handle+0x5b/0x150
[  320.186373]  default_do_nmi+0x40/0x100
[  320.186379]  exc_nmi+0x100/0x180
[  320.186382]  end_repeat_nmi+0xf/0x53
[  320.186386] RIP: 0010:intel_idle+0x59/0xa0
[  320.186389] Code: d2 48 89 d1 65 48 8b 05 55 41 f3 77 0f 01 c8 48
8b 00 a8 08 75 14 66 90 0f 00 2d ae 1f 43 00 b9 01 00 00 00 48 89 f0
0f 01 c9 <65> 48 8b 05 2f 41 f3 77 f0 80 60 02 df f0 83 44 24 fc 00 48
8b 00
[  320.186391] RSP: 0018:ffffffff88c03e48 EFLAGS: 00000046
[  320.186394] RAX: 0000000000000001 RBX: 0000000000000002 RCX: 0000000000000001
[  320.186395] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff972cafa3ffa0
[  320.186397] RBP: ffff972cafa3ffa0 R08: 0000000000000002 R09: 00000000fffffffd
[  320.186398] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff890bbee0
[  320.186399] R13: ffffffff890bbfc8 R14: 0000000000000002 R15: 0000000000000000
[  320.186401]  ? intel_idle+0x59/0xa0
[  320.186404]  ? intel_idle+0x59/0xa0
[  320.186407]  </NMI>
[  320.186407]  <TASK>
[  320.186408]  cpuidle_enter_state+0x7d/0x410
[  320.186411]  cpuidle_enter+0x29/0x40
[  320.186415]  cpuidle_idle_call+0xf8/0x160
[  320.186421]  do_idle+0x7a/0xe0
[  320.186423]  cpu_startup_entry+0x25/0x30
[  320.186426]  rest_init+0xcc/0xd0
[  320.186429]  start_kernel+0x325/0x400
[  320.186433]  x86_64_start_reservations+0x14/0x30
[  320.186437]  x86_64_start_kernel+0xed/0xf0
[  320.186440]  common_startup_64+0x13e/0x141
[  320.186445]  </TASK>
[  320.194588] Kernel Offset: 0x6400000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)


# lspci -nn -s 01:00.1
01:00.1 Ethernet controller [0200]: Broadcom Inc. and subsidiaries
NetXtreme BCM5720 Gigabit Ethernet PCIe [14e4:165f]

# lspci -vvv -s 01:00.1
01:00.1 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme
BCM5720 Gigabit Ethernet PCIe
        DeviceName: NIC4
        Subsystem: Broadcom Inc. and subsidiaries Device 4160
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        NUMA node: 0
        Region 0: Memory at 92900000 (64-bit, prefetchable) [size=64K]
        Region 2: Memory at 92910000 (64-bit, prefetchable) [size=64K]
        Region 4: Memory at 92920000 (64-bit, prefetchable) [size=64K]
        Expansion ROM at 90040000 [disabled] [size=256K]
        Capabilities: [48] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
                Product Name: Broadcom NetXtreme Gigabit Ethernet
                Read-only fields:
                        [PN] Part number: BCM95720
                        [MN] Manufacture ID: 1028
                        [V0] Vendor specific: FFV22.61.8
                        [V1] Vendor specific: DSV1028VPDR.VER1.0
                        [V2] Vendor specific: NPY2
                        [V3] Vendor specific: PMT1
                        [V4] Vendor specific: NMVBroadcom Corp
                        [V5] Vendor specific: DTINIC
                        [V6] Vendor specific: DCM3001008d454101008d45
                        [RV] Reserved: checksum good, 233 byte(s) reserved
                End
        Capabilities: [58] MSI: Enable- Count=1/8 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [a0] MSI-X: Enable+ Count=17 Masked-
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00001000
        Capabilities: [ac] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<4us, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+
FLReset+ SlotPowerLimit 25.000W
                DevCtl: CorrErr- NonFatalErr+ FatalErr+ UnsupReq+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop- FLReset-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq-
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x2, ASPM not supported
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s (ok), Width x2 (ok)
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
NROPrPrP- LTR-
                         10BitTagComp- 10BitTagReq- OBFF Not
Supported, ExtFmt- EETLPPrefix-
                         EmergencyPowerReduction Not Supported,
EmergencyPowerReductionInit-
                         FRS- TPHComp- ExtTPHComp-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 65ms to 210ms,
TimeoutDis- LTR- OBFF Disabled,
                         AtomicOpsCtl: ReqEn-
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete- EqualizationPhase1-
                         EqualizationPhase2- EqualizationPhase3-
LinkEqualizationRequest-
                         Retimer- 2Retimers- CrosslinkRes: unsupported
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt+
UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr+
                CEMsk:  RxErr- BadTLP+ BadDLLP+ Rollover+ Timeout+
AdvNonFatalErr+
                AERCap: First Error Pointer: 00, ECRCGenCap+
ECRCGenEn- ECRCChkCap+ ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 40000001 0000020f 90028090 00000000
        Capabilities: [13c v1] Device Serial Number 00-00-e4-3d-1a-3c-8b-bb
        Capabilities: [150 v1] Power Budgeting <?>
        Capabilities: [160 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Kernel driver in use: tg3
        Kernel modules: tg3

Thanks,


