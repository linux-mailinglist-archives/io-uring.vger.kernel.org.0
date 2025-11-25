Return-Path: <io-uring+bounces-10781-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5E6C83483
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 04:57:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AF2CD34C523
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 03:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC23D275AFB;
	Tue, 25 Nov 2025 03:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CDBgLCYc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1A313AD26
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 03:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764043019; cv=none; b=DRDG2v67v6RVTMhlWvqS9ShwL0CBAkAgeq+NjHOv9WIgAjonpsBJ7meL7myt6ZSDVlcnwUX9A/+6rNg3h3TteYYyrHZYcQb6UdENaTJaGIer3Um9puNYp0Q55NPmQRO7ZTpQL3qZIMEWIYzxc41vMROTdOJgbFC4HnaL0MYfun8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764043019; c=relaxed/simple;
	bh=/XolPWcrw421XZrRdHLgIG2hlWJGaXioyyxUqTM+ZTU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=jdObvDV9A28XZ3uFxcfQoMjUiGwAnwufzTcZ74ItzlurB0Ssq7ZIWcb/hLmLox7f+Eqzm9bjgbKFF++Cbsne5y1Q+wRvio3VivTydK6mQiLU/XSZOTN3PfmH2RoMY5L6HXHwc8+Q/x6q3kyr7/HoYV0LkKfl1Lc3sm0WAHuJD8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CDBgLCYc; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-9490c862fcbso198889839f.2
        for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 19:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764043016; x=1764647816; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AdYd/mx3XkWEoYRhLmhPoH3Jyrq9qNZeAujWjG1ET4c=;
        b=CDBgLCYc5nGZZwBebzrm7Pv1nKYQC+Hg0L34xOez9QyiaPU3ntU4ft0vdxDt1U3qQu
         OLiIbSF4+hGBSPlfFyyJ4Xj/mwrGwcXUbWY5xnwqfcjvHWpTA9gKmB69PRpkEaU2Guki
         0l95MNvPDXovUn+U/O8rXKR5ZXWLGEG3ovf2Jtynxh30g2gWQ2Qz3NZlaueG3R9eOJER
         G+HpDuDOfFaLHINiMrMfx1+gwmaI55sxDXTNlVkyNpHWEFGtMcbBgb7NwKNC5gY8tcFs
         F4GsQR1fZr8wGcmTN7fuOX2R6/xIWg5Y6yC1ZRq/pr3rcgEspwkMKVLJSgcFT8OkpQTq
         IW0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764043016; x=1764647816;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AdYd/mx3XkWEoYRhLmhPoH3Jyrq9qNZeAujWjG1ET4c=;
        b=UyiPXRVPOJfRFyLzyYyWwEo19HdlS+sqVyZEXunfl6RKRdVw1nxSbrjFQJWIdHpFAb
         +KGn6Ixpea0h7Kvq+5MhfHgh5sESyZeAQ/8t03wutg4HOIA6VuThPjZyBfVw1TO2lR8c
         b2/V+6oliFGw0y9T4iY2WiY5xN5KvLxOa/OibPTp363u+vZDgilWo2IYJr7pVHPiT/jK
         1Kizy3kU1/cKTFoNCmuZPou6KD8zKUSslUaTwVpwS8451TFemrMl1aVdogSvF04F0T6M
         tJOT+RPW/1iyNPprEmIxC7SxyDnbgWUe1ZFIHaHEmXNrF4ki746MXUg4EhBkZHvQM+f1
         HoSg==
X-Gm-Message-State: AOJu0YxMPh/RrxQDzEWG4O89YEe+JbigNHkfCUM+HLZgcx+CB0pkb2ID
	wq52spMiS+sVgAEZEg2V4yLicJF3IdaNl6e/O0iwhjh1R3AVKJBCu/qDBDYbwAW7rW3eJSkJztZ
	YRsgiRvY=
X-Gm-Gg: ASbGncsrr0CacTHo3sRPbeg0Eth2jzuTMLUsuAi8XeDVGlpPBZlEAlU7caScPx3wQBA
	hkNuIoeluN22qyc15d+NbkzHSYyhQRThU7fP26mSOhMA99mhUU6uH4th7otK1f5amsetvIbsS4L
	PrCbFRrizTWlijMssfuQ+cCK+LuAu9gYYCrle5OplZ2DEjqwygvrXiawejc//YcgvINGiVwtZ7j
	REFJhzo515WrZNwl2lR6jp/9ijqeNMIpHx03DATlKx8+REmZdTg0YBj+oPrycVajk8mX/WWwlcq
	jEXbPParxHKlXc7plDInL0nebFkU6vhfak4ux0o5KmyTlrofxjjfnhGeJs6hUQzJhBOljVXAOQw
	LfEK4uJ0MbMLvu+JrxyQVahB9whiSfwX4cenr3Sxz4UhGglc9PhrlMr40ERSm72R/DqJlusRmMA
	8wbWnfXCW9
X-Google-Smtp-Source: AGHT+IGyVmHm61Nc4sVOWzEB62Khp3ET1cHpqhmRNK2ZOyEU0oFYGYZjv0SNYW2UF3uFLpDkf7PVBg==
X-Received: by 2002:a05:6602:6411:b0:948:a6b9:3d08 with SMTP id ca18e2360f4ac-949488ae3b6mr1104279939f.3.1764043015989;
        Mon, 24 Nov 2025 19:56:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-435a90d55afsm67406645ab.23.2025.11.24.19.56.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 19:56:55 -0800 (PST)
Message-ID: <e528d7e2-3d63-4bf2-bb14-e8aab5ea9c9c@kernel.dk>
Date: Mon, 24 Nov 2025 20:56:54 -0700
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
Subject: [PATCH] io_uring/net: ensure vectored buffer node import is tied to
 notification
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When support for vectored registered buffers was added, the import
itself is using 'req' rather than the notification io_kiocb, sr->notif.
For non-vectored imports, sr->notif is correctly used. This is important
as the lifetime of the two may be different. Use the correct io_kiocb
for the vectored buffer import.

Cc: stable@vger.kernel.org
Fixes: 23371eac7d9a ("io_uring/net: implement vectored reg bufs for zctx")
Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-463332873@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index a95cc9ca2a4d..43d77f95db51 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1532,8 +1532,10 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 		unsigned uvec_segs = kmsg->msg.msg_iter.nr_segs;
 		int ret;
 
-		ret = io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter, req,
-					&kmsg->vec, uvec_segs, issue_flags);
+		sr->notif->buf_index = req->buf_index;
+		ret = io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter,
+					sr->notif, &kmsg->vec, uvec_segs,
+					issue_flags);
 		if (unlikely(ret))
 			return ret;
 		req->flags &= ~REQ_F_IMPORT_BUFFER;

-- 
Jens Axboe


