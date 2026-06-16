Return-Path: <io-uring+bounces-13754-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id JAEjJnuwMWq6pAUAu9opvQ
	(envelope-from <io-uring+bounces-13754-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 22:22:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DBE06952CE
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 22:22:19 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=proton.me header.s=protonmail header.b=ZSqXwoP1;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13754-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13754-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=proton.me;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5639320A1BE
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 20:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3C0389104;
	Tue, 16 Jun 2026 20:16:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B7938D011;
	Tue, 16 Jun 2026 20:16:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781641016; cv=none; b=KRL7g/WwS9Swj4HbY6JZ+OGBLzqfFQdGV5RKkcWsdOzC1SF+yApEht/auartrgK6JAFWj4LmO7FgWakQj0VWSYQVnryle7I1MOir3EPRF8+XcaGIbr8qNChfqqSW/0rVarRehnH3jRhdNOQFOYMkGORqaNitHIL1anSXzDGGQmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781641016; c=relaxed/simple;
	bh=V1NLVnV77x1FwzmeepuZ5M0qTAvv7JRkHF4W5JsQSXo=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=TwKIT+96Cb5zbZT47bFmxFP1bpf9iqLMjVLLJmKolj1lMBGNTqcyQkxTYBLW7SV+LMUlbd3jjdn04wFQuMyRDDnPBeeHqSR5wzZjbiu1RPDDU6GjJx1RlZM1M6t9HHLeuUC1P5XZ6jfnnA/JrvSoP+vd3VzyeGY3tEe5e1oPcuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=ZSqXwoP1; arc=none smtp.client-ip=185.70.43.16
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1781641008; x=1781900208;
	bh=H3Goi+Y+UYTPjsaFMxwCKhXsIsypsit8EhU2bFsQTZ8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=ZSqXwoP18j95VEpeIPuJrId4YQp29HTTpm39pM4v+fM4XP33kyZUmEu2wzTuoDYLu
	 vFSNW4xOrw0N24Afqk6Fo3+Vkl18qSjujUAiK1/hNYIOS889a9itxmVlcnrm8TF4Af
	 7giJ3PN9MxzKPnw4TfXrhbEgCqDdPA12VfvyZlug20gYFsXH8CjkBAtHH0MduT6G6q
	 6fEzS5XFR6q7Ujq3uOZOcYJ6mZwcBs8gVNFDa5KegSVOhmtC5LGUkpA/iwKXGNfMaP
	 VgcZxB3NfyA/SC5L8hVen29zPm6czIiC99C3o6Oy7Bp0P9iP/Kh+M0GUFy1sfd1xWK
	 Gl+tpnYLLcf+Q==
Date: Tue, 16 Jun 2026 20:16:41 +0000
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: =?utf-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, linux-security-module@vger.kernel.org, io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Landlock: LANDLOCK_ACCESS_FS_IOCTL_DEV bypass via io_uring IORING_OP_URING_CMD
Message-ID: <20260616201633.275067-1-hexlabsecurity@proton.me>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 3e618764aa8d1c1ba3df37c48f031a42fe7e9e1c
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[proton.me,quarantine];
	R_DKIM_ALLOW(-0.20)[proton.me:s=protonmail];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:mic@digikod.net,m:gnoack@google.com,m:paul@paul-moore.com,m:axboe@kernel.dk,m:kbusch@kernel.org,m:hch@lst.de,m:sagi@grimberg.me,m:linux-security-module@vger.kernel.org,m:io-uring@vger.kernel.org,m:linux-block@vger.kernel.org,m:linux-nvme@lists.infradead.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13754-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[hexlabsecurity@proton.me,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hexlabsecurity@proton.me,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[proton.me:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[proton.me:dkim,proton.me:email,proton.me:mid,proton.me:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3DBE06952CE

Hello Micka=C3=ABl, and Landlock / io_uring folks,

A task confined by a Landlock ruleset that grants READ_FILE/WRITE_FILE on a=
 block
or NVMe character device but withholds LANDLOCK_ACCESS_FS_IOCTL_DEV can sti=
ll
reach the device-command surface through io_uring IORING_OP_URING_CMD with =
the
IOCTL_DEV check bypassed: the request enters the device-command handler (bl=
ock
discard, or the NVMe char-device passthrough) where the equivalent ioctl(2)=
 is
denied. The destructive completion and the NVMe-admin surface follow from t=
he
code -- see Impact.

Affected
--------
Any kernel with CONFIG_SECURITY_LANDLOCK=3Dy and Landlock enabled that supp=
orts
LANDLOCK_ACCESS_FS_IOCTL_DEV (Landlock ABI >=3D 5, since Linux 6.8) and io_=
uring
uring_cmd for the device class (block BLOCK_URING_CMD_DISCARD; NVMe passthr=
ough).
Confirmed by source inspection on mainline (v7.1-rc7) and reproduced on Lin=
ux
7.0.11 (Landlock ABI 8). The confined task needs a writable fd to a device =
it is
legitimately allowed to use (e.g. a partition/loop device or an NVMe namesp=
ace
passed into a container or granted by the ruleset); no CAP is required to r=
each
the io_uring path. The gap is structural -- Landlock has never registered a
uring_cmd hook -- so it is present from ABI 5 (Linux 6.8) through current
mainline (v7.1-rc7) and is not a regression tied to a single Fixes: commit.

Root cause
----------
On the ioctl(2) path, the syscall handler in fs/ioctl.c calls
security_file_ioctl() (its only call site on the ioctl(2) path) before
dispatching to do_vfs_ioctl(); that reaches Landlock hook_file_ioctl_common=
(),
which denies a device ioctl unless the file's
allowed_access holds LANDLOCK_ACCESS_FS_IOCTL_DEV (BLKDISCARD/BLKSECDISCARD=
/
BLKZEROOUT and NVMe passthrough are not in the is_masked_device_ioctl()
allow-list, so they require the right).

io_uring reaches the same device-command surface by a different producer:

  IORING_OP_URING_CMD -> io_uring_cmd()   io_uring/uring_cmd.c
   -> security_uring_cmd(ioucmd)          (the ONLY LSM gate on this path)
   -> file->f_op->uring_cmd()             e.g. blkdev_uring_cmd() / nvme_ns=
_chr_uring_cmd()

Landlock's LSM_HOOK_INIT list (security/landlock/fs.c, net.c, task.c) regis=
ters
file_ioctl/file_ioctl_compat but no uring_cmd hook -- only SELinux
(selinux_uring_cmd) and Smack (smack_uring_cmd) gate this surface -- so
security_uring_cmd() returns 0 for a Landlocked task and hook_file_ioctl /
IOCTL_DEV is never consulted. For block, blkdev_cmd_discard() is then gated=
 only
by BLK_OPEN_WRITE; for NVMe, nvme_ns_chr_uring_cmd() reaches the admin/IO
passthrough with no security_file_ioctl on the path. There is no shared hel=
per
that re-applies the IOCTL_DEV check.

SELinux and Smack hooking uring_cmd while Landlock does not is the coverage
asymmetry; the Landlock documentation describes IOCTL_DEV as gating ioctl(2=
) but
does not mention io_uring.

Reproducer
----------
A self-contained PoC is available on request (it needs root only to set up =
a loop
block device and open it; Landlock enforcement is uid-independent, so the
confined child demonstrates the gap regardless of the setup uid). The child
applies a Landlock ruleset handling READ_FILE|WRITE_FILE|IOCTL_DEV with a r=
ule
granting only READ_FILE|WRITE_FILE on the device, then:

  (1) ioctl(fd, BLKDISCARD, range)        -> -EACCES  (Landlock enforces IO=
CTL_DEV)
  (2) IORING_OP_URING_CMD,
      cmd_op =3D BLOCK_URING_CMD_DISCARD     -> reaches the block command h=
andler

Observed on Linux 7.0.11 (Landlock ABI 8):

  [1] ioctl(BLKDISCARD)   -> ret=3D-1 errno=3D13 (Permission denied)
  [2] uring_cmd(DISCARD)  -> cqe.res=3D-22 (Invalid argument)

A Landlock denial is always -EACCES; the io_uring path returned -EINVAL, wh=
ich
originates in a post-authorization check inside the block command handler
(blk_validate_byte_range() in blkdev_cmd_discard()), reached only after
security_uring_cmd() returned 0. So this run demonstrates the authorization
bypass -- the request traversed the LSM gate into the block device-command
handler with no IOCTL_DEV check -- and then failed a parameter check, not a=
n
authorization check. The destructive completion (an authorized discard with=
 a
granularity-aligned range) is the expected behaviour but was not exercised =
in
this run.

Impact
------
Demonstrated: the LANDLOCK_ACCESS_FS_IOCTL_DEV authorization is bypassed. T=
he
device-command request reaches the block command handler with no Landlock c=
heck;
the only remaining gate is BLK_OPEN_WRITE (held, since the policy granted w=
rite).
Inferred from the code, not exercised here: an authorized DISCARD with a va=
lid
range completes (DISCARD/secure-erase semantics, destroying on-device data)=
, and
the same missing hook leaves the NVMe char-device uring_cmd surface ungated=
 --
nvme_ns_chr_uring_cmd (namespace device /dev/nvmeXnY) -> nvme_ns_uring_cmd =
for
NVME_URING_CMD_IO/IO_VEC passthrough, and nvme_dev_uring_cmd (controller de=
vice
/dev/nvmeX) for NVME_URING_CMD_ADMIN (format, sanitize, firmware download,
security send) -- both reach f_op->uring_cmd with no Landlock/IOCTL_DEV gat=
e.

So the confirmed finding is a missing authorization (the confined task esca=
pes
its own IOCTL_DEV restriction); the destructive data effect and the NVMe-ad=
min
high-water-mark follow from the code but are not shown in the run above. Th=
e
proven authorization bypass alone scores CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:C/C=
:N/I:H/A:N
(6.5 Medium) -- S:C because the confined task crosses the Landlock policy
boundary it was placed under, I:H because the bypassed path reaches a handl=
er
whose authorized completion modifies device data. With the device command
completing destructively the projected ceiling is
CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:C/C:N/I:H/A:H (8.4 High), the A:H component
reasoned from the source rather than executed. No memory safety is involved=
.

Suggested direction
-------------------
Have Landlock register a uring_cmd hook that maps the device command to the=
 same
checks the ioctl path applies (IOCTL_DEV, and truncate where relevant), so =
a
single chokepoint covers every f_op->uring_cmd provider (block, NVMe, ublk,=
 and
any future one). Mirrors how SELinux/Smack already gate this surface.

I am happy to send a patch for this if you would like.

Best regards,

Bryam Vargas
Independent security researcher, HEXLAB S.A.S., Cali, Colombia
hexlabsecurity@proton.me


