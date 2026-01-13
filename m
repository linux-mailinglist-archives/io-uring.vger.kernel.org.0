Return-Path: <io-uring+bounces-11602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C96D162A1
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 02:28:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E70E53026BC0
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 01:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBDD26CE2C;
	Tue, 13 Jan 2026 01:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dBGjGh4Y"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0982A26A0DD;
	Tue, 13 Jan 2026 01:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768267652; cv=none; b=kzPydJHazgmuO2NboUcVCaE7FWCj3HXgFk6pu6CqpPRTgkUVZ9n7u3eDJYHCp3KNgXhdvEGB0aLAPOY//8NgTk05QfMTHzzY5dkAggQObPWl0AEta+aQswz2tT29OKZ6iQ8Qny6cUOREgNikbhVlYtBAVSncQ1lEJYTHj+1YzGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768267652; c=relaxed/simple;
	bh=76vsM9dInD+9+R83gb+JrIDnHztg8lRVm8PtLdAi5YE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D02JXl6qutonZ2Kw48j3RG485x56e232bprT2YmJecHyUypXgsL0UXg10ueCTabNrq3aQ7QmUUGK8iaKONsxwcmqAL94DqTjOzVogV55cidLDyItblHVGDVhCyvbd1DR4u5UTqDWJZztkWfA610+8PI3R1Vnyu2j/4hNWDmUf8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dBGjGh4Y; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=hr
	XX02ZvoioE91N8AtKvPuslKoB2fjoV/daKsCJ+BcM=; b=dBGjGh4Y6EUmFB+tYD
	oBs21JyVblJnJWpNAKwj0Izzgg35f3umLobRtCPqVAZeDVnT6R8c7fp6Z1Dh4gAq
	DPKyyTJl9gULyQ44wCVWF3/gscINzCI/2CdXM1AnF38JejnGHMBQ3wQ/LfYwRT2G
	88h20LvDpb9Nd2fOZpOEH+5kc=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDH8O9Qn2Vp9UvxLA--.193S2;
	Tue, 13 Jan 2026 09:26:43 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: bart.vanassche@wdc.com
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: Re: [RFC PATCH 1/3] bsg: add bsg_uring_cmd uapi structure
Date: Tue, 13 Jan 2026 09:26:35 +0800
Message-Id: <20260113012635.1638557-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <93b11693-3734-48ff-8039-29fc46a17cc6@acm.org>
References: <93b11693-3734-48ff-8039-29fc46a17cc6@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDH8O9Qn2Vp9UvxLA--.193S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF1rtw18Wr4DCw1fCF1DGFg_yoW5JFWxpF
	43Kr48GFs8Xw12vw47ZFsrZa1ayryxJw47Ga43W3Z09F4DZryxua42kFZ2qa12qw4kZ3Wj
	9w42g34ruw1IyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRcJ5wUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwROvQGlln1Oq2QAA3O

On 1/12/26 17:44, Bart Van Assche wrote:
> On 1/12/26 1:46 AM, Yang Xiuwei wrote:
> > +struct bsg_uring_cmd {
> > +	__u64 cdb_addr;
> > +	__u8  cdb_len;
> > +	__u8  protocol;		/* [i] protocol type (BSG_PROTOCOL_*) */
> > +	__u8  subprotocol;	/* [i] subprotocol type (BSG_SUB_PROTOCOL_*) */
> > +	__u8  reserved1;
> > +	__u32 din_iovec_count;	/* [i] 0 -> flat din transfer else
> > +				 * din_xferp points to array of iovec
> > +				 */
> > +	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
> > +	__u64 din_xferp;	/* [i] data in buffer address or iovec array
> > +				 * address
> > +				 */
> > +	__u32 dout_iovec_count;	/* [i] 0 -> flat dout transfer else
> > +				 * dout_xferp points to array of iovec
> > +				 */
> > +	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
> > +	__u64 dout_xferp;	/* [i] data out buffer address or iovec array address */
> > +	__u32 sense_len;
> > +	__u64 sense_addr;
> > +	__u32 timeout_ms;
> > +	__u32 flags;		/* [i] bit mask (BSG_FLAG_*) - reserved for future use */
> > +	__u8  reserved[16];	/* reserved for future extension */
> 
> BSG supports much more than only SCSI. The above seems to support SCSI
> commands only.

While the current BSG implementation only supports SCSI (BSG_PROTOCOL_SCSI
is the only defined protocol), I understand that the design should allow
for future protocol extensions. I notice that sg_io_v4 uses generic field
names (request, request_len) rather than SCSI-specific names (cdb), which
aligns with this design philosophy.

I'll change cdb_addr/cdb_len to more generic names (request_addr,
request_len) to match the naming convention used in sg_io_v4, even though
the current implementation is SCSI-specific.

> > +} __packed;
> 
> Applying __packed to a data structure in its entirety is wrong because
> it causes compilers to generate suboptimal code on architectures that do
> not support unaligned 16-/32-/64-bit accesses.

You're correct that using __packed on the entire structure can cause
suboptimal code generation on architectures that don't support unaligned
access. I'll remove __packed and reorganize the fields to ensure proper
alignment while maintaining the 80-byte size requirement to fit within the
128-byte SQE cmd field.

I'll prepare a revised patch addressing these issues in the next version
of the series.

As I'm relatively new to kernel development, I appreciate your detailed
feedback. I'll incorporate these improvements and continue learning from
the community.

Thanks again for your review!

Best regards,
Yang Xiuwei


