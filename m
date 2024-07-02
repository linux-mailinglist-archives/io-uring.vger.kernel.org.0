Return-Path: <io-uring+bounces-2415-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71EDE92429A
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 17:42:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A36591C2286F
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 15:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E3C16C69A;
	Tue,  2 Jul 2024 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e295RM+H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F3D14D42C
	for <io-uring@vger.kernel.org>; Tue,  2 Jul 2024 15:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719934929; cv=none; b=eTE+VrBqszZGoc/HD4hb9mmZ4SFmFoh5TVoLghyWUeMyTR8eIGKyjQv6N/Ao8TCFKs9mS2i33RupNSTA9y945R4n9w0m1EzWt7t8VbsPz2mN4XL5c62hw/nS6iILOZq9+kT7HRN3g7nVIaDC4tFvbgcNHIalBkQxk0ukKYPP44s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719934929; c=relaxed/simple;
	bh=nX/rvwTgcJlHFj7S4CZ35ZoROLoXlqTj1rLFvAZoLHw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=SklcPoF2M0BDK30lRTDvjbbV1igzmN7kZ1dy4/PKxXBc/zBD1N5umXKtttfYetjaVLo1PBOO3SHtz1cZFmSawLxNINv9AG6jyOTPgAh8BnzLsjJAjiHddhSfg/aptn+9f4JcL/KvPkJI33tiA5pYazWrIT9gff1dtQiduaZNbMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e295RM+H; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5c451f68160so34707eaf.0
        for <io-uring@vger.kernel.org>; Tue, 02 Jul 2024 08:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719934923; x=1720539723; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylYcHoZzWdtP9PF9CSLizWHwLceShucGyMIUKBGy03o=;
        b=e295RM+HJ6KmtNP6Xc18noII0z/sYXOwUesNgGj9h+FmbAR67GRlvEy8OflYciJt3Y
         ky1boQtB8DD3Qz2VeJ8myw8RnX4ALDNdWJ370bOJf9uVheBozKhsMhaJTRD0VhwP/+LX
         1LU2EJL0MV7dyLFAWeTlezU2hAaBb4e9mmw+Gr/2tEnCvC65IBFMbV3HG0NJbS8FVkma
         Ut97jWaoDcv4X1S+ekFdWs+2MfJ5Ayx40CfFA8ZNzsXQzou6oTR/ld2UYCa+GQHF+vrj
         H+tNmy5RGKDOuzK4PvlPqFbhQ8a46BTgyxXS1L+CzJWS5izwybHobLri+Bm6gE4WnNTF
         pSvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719934923; x=1720539723;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ylYcHoZzWdtP9PF9CSLizWHwLceShucGyMIUKBGy03o=;
        b=KM55u97/Y8Cf/Gn8RBxDfBrlBcUCeVcm7eUUKI2+bYGsNnE0WbmVm5A2eG7+Cu7ab0
         ouiYST15T5DbefJCIE3bXeVsVdOdK4q3gjyyZRakZ2FOptm91M9jvdri6ZzgmsGITY5+
         ugdKMg3EU58GtzPTebkRFCrzlV+hPO90z790SAopdYBOfWn6ow0A/S3HS4cw4hstaD8w
         PLb60vq3P69G+3NPdyCBwr7pBFogVCtKcwh7xb/j0GF9uJ0g4/8kACtP8k87iSUJEnio
         1bsIq6hwIJ7O0psb3CKCDCZUjJrUtermQeu43JZ3AZ0jxpDyuwzKxLa1ni4f6gvd2l0t
         9ADQ==
X-Gm-Message-State: AOJu0YzUKmOgoUOsiUL7dbns8DuRK/wakZVAQdifuYw9evgP6ZomEzA9
	in0QZ4cS67k4xKEosxHmXu2lGlYW0+Ib1UhBtR4n3H8OlNokcf5F1kuoQq3x+9Jr9YCjbC/NIZ/
	asxQ=
X-Google-Smtp-Source: AGHT+IHn3H88ox7bB/NhJjry87xL/MIbCvhGeubayLwKGsAnfLxMkFJzPfznDpydwgu6hx4LJh0GfA==
X-Received: by 2002:a4a:b3c4:0:b0:5c2:20aa:db25 with SMTP id 006d021491bc7-5c438e43fa9mr8596448eaf.1.1719934923357;
        Tue, 02 Jul 2024 08:42:03 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5c414835d09sm1330332eaf.11.2024.07.02.08.42.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jul 2024 08:42:02 -0700 (PDT)
Message-ID: <28765b7a-20e6-427f-a18e-5f0e605ed403@kernel.dk>
Date: Tue, 2 Jul 2024 09:42:02 -0600
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
Subject: [PATCH] io_uring/net: don't clear msg_inq before io_recv_buf_select()
 needs it
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For bundle receives to function properly, the previous iteration msg_inq
value is needed to make a judgement call on how much data there is to
receive. A previous fix ended up clearing it earlier as an error case
would potentially errantly set IORING_CQE_F_SOCK_NONEMPTY if the request
got failed.

Move the assignment to post assigning buffers for the receive, but
ensure that it's cleared for the buffer selection error case. With that,
buffer selection has the right msg_inq value and can correctly bundle
receives as designed.

Noticed while testing where it was apparent than more than 1 buffer was
never received. After fix was in place, multiple buffers are correctly
picked for receive. This provides a 10x speedup for the test case, as
the buffer size used was 64b.

Fixes: 18414a4a2eab ("io_uring/net: assign kmsg inq/flags before buffer selection")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 7c98c4d50946..cf742bdd2a93 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1127,16 +1127,18 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		flags |= MSG_DONTWAIT;
 
 retry_multishot:
-	kmsg->msg.msg_inq = -1;
-	kmsg->msg.msg_flags = 0;
-
 	if (io_do_buffer_select(req)) {
 		ret = io_recv_buf_select(req, kmsg, &len, issue_flags);
-		if (unlikely(ret))
+		if (unlikely(ret)) {
+			kmsg->msg.msg_inq = -1;
 			goto out_free;
+		}
 		sr->buf = NULL;
 	}
 
+	kmsg->msg.msg_flags = 0;
+	kmsg->msg.msg_inq = -1;
+
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
-- 
Jens Axboe


