Return-Path: <io-uring+bounces-13643-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id NDkFNxn3JmqiowIAu9opvQ
	(envelope-from <io-uring+bounces-13643-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 19:08:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 279C065915F
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 19:08:41 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=fkqSp4ZH;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13643-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13643-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 11C2C36C6756
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 15:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248873DB32F;
	Mon,  8 Jun 2026 15:38:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF1A3E5580
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 15:38:40 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780933123; cv=none; b=YwOwNGL3gMPg11ZLQX2MSz0kYHuDpi2eAfiGkgDU+86A3OuJXR8v3rBpP5lM15hO979fGYSbh+fpMCkaZ4nyBeSkAWwfWdHY+uXnDBbStdibPJbTyM5qpB9H8zjcz31eBZUgQlnyVXvhCGe72COvVQnibTEHgEc1ojkWCuxtycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780933123; c=relaxed/simple;
	bh=tks+DeU08AXC9WeLb5QxDE1DajYoXgvda5+ITYk7yMI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=npjK9BI+4XtilylqoyX2ms+ZryXllxEi0xQ5Y8ZuiClWlZvcel0zpJAirpMuXIkpVozEumS/zCZUJcILFd3W6cvmU/tVAQvKDDKym5qt2HeGyOBCbW5oh4DYnJ+RSXp00vhum7HGa5CssOoLBLAvryg+qcrdWrT4AEgdG9kQhFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=fkqSp4ZH; arc=none smtp.client-ip=209.85.210.43
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7e6c047c6bfso3414549a34.3
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2026 08:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780933120; x=1781537920; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gh2Zpo4f+dUslv/4bWuUDt9wi7TcFx/zb0Plx18O8Gc=;
        b=fkqSp4ZHmyVsCfwmgzisTaoo3ExMbQzWQLeMo5NzeRAmlwA5k+OmBdHKkE6CmAq221
         hsx18+kr/lDNRKbfMrSHU4yCUDhA9ycSJL7ryaFSZK/UBE9URhzJtHxCEqE1P5TI9oUz
         kL8127BKdcDpYzqJ1jfSLow4FHHcrq/vOiThJgy8hI/ni0+R9EwfeC4MGOF2t+FFBJmo
         sJ1oIuJA6f75BgglLJVzveOSnjhS3MXp9k8Jow+v18uVI+fZnfv/ntmnGqzTl7O7VW6g
         0LhNQjWASBkBRm1LsyRmBCNhEXtUdDrBrVk9l89sjM1OAsG27fgwANZAvqPRa9WAeJuC
         3Mtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780933120; x=1781537920;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gh2Zpo4f+dUslv/4bWuUDt9wi7TcFx/zb0Plx18O8Gc=;
        b=JjV/+NINU/fLssuIRZTkuGnu64J/Pi88+fO8t1N+TCX1frfr/OVTP46ECebUIJMV+J
         +ZcwAJa0Rw1qUiCCJVeTEmvv3biV9R/COHPvya28IxcUAb2S5ypVs/FjtVoUA1qBE2IN
         ecr2GlhgGKkYsC9otKaegU3TUOnwlDtfr0KdJDumj9riKmPlH71rcNSuaKgyEeTc/iu8
         QQhq6iq7MS3R98JPcDJoq0FTN8muSpzsIR4A5vVhxl6km0wkF6G4QwzLz7nNLr1wyh4e
         Q46i01nTl8dQvHp9IRFE8WunI+brOwd9Oumi64CbKraYSDJRSAFv9Lihz8Fpijby9C8J
         K4nA==
X-Gm-Message-State: AOJu0YyQ5RDtblkbvC0M2uDRMDpF0q5Rbm4TMTjS03o9H2sqLxlMU5hX
	YlqVBSFk/zfKKxvAOdXFEBVn0x619Go4KtpuWGajJNUDsPr1j7IB1UOTbYZYU0/0k2Fm3Wx4fR4
	p1HoO
X-Gm-Gg: Acq92OGdOav1mZ+M6etiRNABPT0IbwfplTZ2OBT2lzPzs8gV6WswyNOkRfNB2BsMxXE
	I2KB0reXta4siDesm6ZUTAfExb84E4J81c9OHoFAhnBP2SVn4KMh/FoYIPEwZIm/pY5sQTjLBdv
	XKmMprBwUCbs15Ss2A/sMrKCN6acYyyyzOuusW0xWydlFxT7qOaU1QUnOYre6H+MlQbRiXb2phT
	ILaYeSeg5Kwl9QDlAQp1A82SzixssfHei9Sc+d32Pnv3mIke05Nhg0d/hpeYppV8bVty7PLNqcu
	PLxOXQFtpej3AUL+F3BfQfqj7MmDRRdH3Zf/PS7LM6OvOrHVkMSX9eTUEc/6EeF7FNKeJ3L4eUQ
	3HDY6U/jC27ncqqYmO06WbcbujJSuQcOGpU8Fa/fX5i/NzUFj/p++WwApUwWy/bwOU6c0oyRzNc
	LWkL3KfJeNNnuIYWDu+dUsq5JeIpVwOQ1djUnbHeIl16fAoxWdXShQhJQASm4OIIAcwNgzHLwfj
	yFahNBmFi0HajbCeFY0
X-Received: by 2002:a05:6830:4890:b0:7e6:fe3a:b777 with SMTP id 46e09a7af769-7e70c8fd714mr10115361a34.13.1780933119899;
        Mon, 08 Jun 2026 08:38:39 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6e75c5495sm12209606a34.10.2026.06.08.08.38.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 08:38:39 -0700 (PDT)
Message-ID: <a629a780-2ad3-4afb-ae98-70d2cbcb963b@kernel.dk>
Date: Mon, 8 Jun 2026 09:38:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring/kbuf: validate ring provided buffer
 addresses with access_ok()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-13643-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 279C065915F

Ring-mapped provided buffers store buffer addresses in a shared memory
ring that userspace populates. When io_uring reads buf->addr from this
ring, it converts it to a user pointer via u64_to_user_ptr() without
any access_ok() validation. This is OK as the iov_iter copy accessors
validate the address when it's being used, but it's also different
than any other address import where it's always validated.

Validate the provided ring buffers at import time, unifying them with
the other access methods.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 7a1c65f631c2..a34db556a75c 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -250,6 +250,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 				struct io_buffer_list *bl)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
+	struct iovec *org_iovs = arg->iovs;
 	struct iovec *iov = arg->iovs;
 	int nr_iovs = arg->nr_iovs;
 	__u16 nr_avail, tail, head;
@@ -311,6 +312,11 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 		iov->iov_base = u64_to_user_ptr(READ_ONCE(buf->addr));
 		iov->iov_len = len;
+		if (unlikely(!access_ok(iov->iov_base, len))) {
+			if (arg->iovs != org_iovs)
+				kfree(arg->iovs);
+			return -EFAULT;
+		}
 		iov++;
 
 		arg->out_len += len;

-- 
Jens Axboe


