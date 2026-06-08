Return-Path: <io-uring+bounces-13646-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id FIMvKRL4JmrsowIAu9opvQ
	(envelope-from <io-uring+bounces-13646-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 19:12:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F1A6591F0
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 19:12:49 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=tCZPbFnR;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13646-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13646-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7DCB2300BC70
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 17:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD6E3469E7;
	Mon,  8 Jun 2026 17:04:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F78372062
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 17:04:47 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780938289; cv=none; b=Si9S/xVZ3+Z4i483Ygeq/GJ6r/O/ULMKkq++ghSMIjbwaW0rTvvG72sV9opWbPGbJxK8rnYtTTmwRe+m37yXuQXLnabAfw5mIep/WquC0iwg36gyRHbvajVwkWiIHegc5793g63sqZL9ZZTZ8YP81FtomOoGf64k3X5PWrcPh08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780938289; c=relaxed/simple;
	bh=iO0jwcrVeX572EpLGbUBLieuZ4EvCiblV8R9LjEiies=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=sANu03sncIrbUCl/Ca4nb84svSQCcT0vqykZBm5UmjMQSQhJaXyeEePrTOMxmsn2eZfwvNp7eIElllKR7Ow5FwNvNnZIjL3SmT+O4Zxm+ojSqrs+E1jSLMlxKtWllGzeemhqrp+QlzKaYj+UMRaZeon7DH8sltSFMxf/5jGWMhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=tCZPbFnR; arc=none smtp.client-ip=209.85.161.49
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-69de9bc590aso3344908eaf.1
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2026 10:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780938286; x=1781543086; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gockCAxwzOZKw78Witi0rdR+HbG3WtW/dZz9lbyKdBE=;
        b=tCZPbFnRYDmbnOiwdAujOklHYhenSGhkdPp5Cna3W7/bwlYfelFNDTT9aJgvVY7CvJ
         5kJGGFVZuSq+S9RzjiP9LEWDXSPCDmOOLE/+eBRf+S8eQyzeYQ9qra8t78M0OFcmD9Q4
         eDslrr8IUeBAEwlIbzKWS4yhwSAtg/UuSwbNeNXrgWh3j8yDZOFpbhafKBgMCgoRRgGU
         jJ8vtc+UXlP5dbflwAvIxrGVrJ4vVCPChShmrDovBxFGb2/ZAlnYOSWQFesloqfawpKx
         ZEi2WgRPojrXZFe5FlxX2OHKjRvmyTpEZS26K654J929omPQ/uMh0TFny244hm+t9Xjp
         yjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780938286; x=1781543086;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gockCAxwzOZKw78Witi0rdR+HbG3WtW/dZz9lbyKdBE=;
        b=jBy7iYegfI9GCoEM6d9WKOemdnRbDtSj5ECiDy3VbLCuttBc0u26eNR6Uts17wr4qa
         Ilafq7Kc+l8g6xAu3rdxonfLsh4nVEHMzn2SgR2OfZC5wxMg460mGBS/gVOQZAeAhnNZ
         3uCFOKLDEGkb6HSOh1fy5V206KMwZh3+PZhxeZ9sN9bxOEX8zV15RKohMSzFGGMGcNX5
         mKoWRyc+i6Rk5fs+Xi2nWTFo+IJKGQp/B7XS4CDboXccTJs17a2VhpNmECX2TL1BfRxc
         amYHhBaR+S760eCAanHgiQHbaJCcarszk/YNHthLsOuS7uCqJxM6Qi5vNcEiy1br9laY
         Ob7Q==
X-Gm-Message-State: AOJu0YwBGkjxYNvZiIsnZZkKGxJNPKdPFwKvvy+m6pVdXzPD2Ivwx5ke
	CC0Hztpe0eOaRwf7yr3WNHN0KWXkI5AtweMu3iCnTpagNiUB5yNyXrmPMXllGPr1fUVEcMLSur1
	dzuM4
X-Gm-Gg: Acq92OHosKgS0aQ4LA0GJfZjXhf5EBky3sKzeEurYtvtD/Gde16EA7peykDpvPnya/g
	BzwakWPwkYXh9OlXqjIagc3dggKGpD/+sqmg/w1g9PQWdWax3NCcwU0+tFWRUcJ77zsVQkrUGUa
	APR2+xAI1pKe25TkcHfgjlYs3C2/ykuuRt9Or7YsyS2U4SMgRGvzcKtmjltv1yGybqiggJ+PDS5
	+xijVVwJkl3qm8sRpHbRKNA9LvtjZsdI0l3GG6yLxOhRhYaFmMo+saS2xhRqhWdwtGKF4cRp/p6
	IDmt2LuaarfaK9W/LWOhW8ItqyqfWj3O57b6qdIbTmWT4rVHCfLx0fpTuCcPWKWs1qy6HevVWPk
	KHrvPid71w2VA+JQ/DPuL0LcpxdyBA15+CCE3KMaijBnoj/27MlNvl+gpZq24Xm/EovbFhrP+qj
	gMdvhxN4fLJh3PYbsacWPRlC5zoyDvyQnQKeU+dBn3r0ptmHLmk4411pfDIBS/D2ccXtSdshuXF
	RMjwAPMVKsI8Zov/XSI
X-Received: by 2002:a05:6820:1c87:b0:69d:9b72:8151 with SMTP id 006d021491bc7-69e68c58c70mr8540843eaf.41.1780938286011;
        Mon, 08 Jun 2026 10:04:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-440d7263efcsm16915902fac.0.2026.06.08.10.04.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 10:04:45 -0700 (PDT)
Message-ID: <30488562-4053-4b68-b2aa-3e8e3ea5cef6@kernel.dk>
Date: Mon, 8 Jun 2026 11:04:44 -0600
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
Subject: [PATCH v2 for-next] io_uring/kbuf: validate ring provided buffer
 addresses with access_ok()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-13646-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,kernel.dk:email,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A2F1A6591F0

Commit:

809b997a5ce9 ("x86-64/arm64/powerpc: clean up and rename __copy_from_user_flushcache")

sanitized that any provided copy helper should separately validate
destination and source addresses, but we should also ensure that
anything that is retrieved from a buffer is validated upfront. For ring
provided buffers, always include an access_ok() when grabbing a new
buffer.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: send actual patch, not an old version...

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 7a1c65f631c2..b9f4720ca22f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -210,10 +210,14 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	buf_len = READ_ONCE(buf->len);
 	if (*len == 0 || *len > buf_len)
 		*len = buf_len;
+	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
+	if (unlikely(!access_ok(sel.addr, *len))) {
+		sel.addr = NULL;
+		return sel;
+	}
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
-	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
 
 	if (io_should_commit(req, issue_flags)) {
 		if (!io_kbuf_commit(req, sel.buf_list, *len, 1))
@@ -250,6 +254,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 				struct io_buffer_list *bl)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
+	struct iovec *org_iovs = arg->iovs;
 	struct iovec *iov = arg->iovs;
 	int nr_iovs = arg->nr_iovs;
 	__u16 nr_avail, tail, head;
@@ -311,6 +316,11 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
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


