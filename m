Return-Path: <io-uring+bounces-4978-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD59C9D61EA
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A25B8160849
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 16:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D50AD2F;
	Fri, 22 Nov 2024 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bO3rs31w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073A31DEFFD
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 16:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732292217; cv=none; b=dEtkl2//RdkjnWcCPL+82+3zut3dcP2mOpQgCuPPVvReqepwzH7gp+MwM9TNyzt142pAtln9E2KHlbbAxzNYvSeDoclpSDb4jeo/z4ThgxCqenFhQLlQN8BJha/bsaT/fq9imR5+rZPy3rr2ZJtA47dc1l5pk/Gw2BpXKWw57DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732292217; c=relaxed/simple;
	bh=+DHAUY6acGwCf5k1bOSelonQxNO0aX/NS/jsXA9/eKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbQ02X441syfIu0U3snu2MZU2Jh2WcLupKGZVmVeEpPtWv2R3qaT6Z6wc2+osPB0juUr0n+sW2ByvQojK9gbckD/Y99nKsn3nisJ8HTRJwErxu88WK5Q/DV5kJoOmPnvFY/ykyJNDU0D+ymf/fsZboT7QsugIp0b0JHDlhuKwb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bO3rs31w; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-2973b53ec02so88028fac.1
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 08:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732292213; x=1732897013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qefPjpPCJpGhgrdxo9V7RKjuQexAKAK6JHZ2wpLql9I=;
        b=bO3rs31woBy5kqzrnk8gJ/hYV1NNfmB3QFPJ4K94voKapiuw6I7rbEs9aXx2+carhd
         RRWpX6V9w2XIjONJb9/HP7L4yZGcirjfWk2wpBDo7ipMv3xEeoPnAipfzf5RYHLaVga/
         PITtaQutSL6LSAYLRGikUEDgPUKnTK0y4P0lLWqiPhT7BcPPCjUCUAYjGt5E53TbcLx/
         YLFWJmdE2Aty6JU+XqY2YhPeEpmgmWdP+62wbZJN923Srm932kbkxo3Mu+Ma5B/vJztg
         eMtKTlIXh2xfQ1evM77sRJRiXc8Obn4NoBQORGXnpE9z/ljMa9M5tfDt7kZqaQM++FQt
         BQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732292213; x=1732897013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qefPjpPCJpGhgrdxo9V7RKjuQexAKAK6JHZ2wpLql9I=;
        b=OwSBjZsCSj/2qTlCo/q20RJccFVAh6PuDC+oUpHauxmUSDw5aaiBBf5VH0ytQs9Jn7
         3+Ywaxije5ApErtMD3r/3SM4+f/736zqlJP5eK8cpSQKuhQSnZEEqf5QZf1y3HJtIIlO
         8jf/s2Z1WVjCESTnAAMa3uI1Dmxm2dXxoas8vjFEYHpCt5z8fqaubZUqwDiGsYIORaCh
         BcUFK0liIi8ul0EesKI3ELJ5YDf6WEydGThB08l7tmy+fTwm+u08IGVCLYDlPGYJyika
         fy9DW1mntwD/1XkfCYjVI8xIlIBR0vh19hwcYjrwpyrwuIqw3q4BIDTiUezUQJKLaJt+
         lvWw==
X-Gm-Message-State: AOJu0Yz5y1ZLkvGpSJra3q9cuHnhLgQiMYWOncIfBnvG0J724taV5Ahy
	VgAfTfxYewrXBO4snqBivEGTN5IoMNaL4hKFowdNSwrB+Z2b00OW5rqLfKu92mgfld2BOGFDYho
	YGT0=
X-Gm-Gg: ASbGnctnk5BDANxawV9hNtRlgDbndPruQWhUcQrubSlvIIZxPesbVsBkTTrLSmP8Xdc
	Ma+7Kxsea2RJMVO/ZJtOmppugncGSo7GfnIbsEshGGfk5hqfXSFHjrkc9GsAkWEabq1kgz+zcKH
	x4KNCpn0gki5m8e80cafmzkqZwTLcPmRgsGdzGcJBan5l+KEbQqAFjO8sL0zQ/hUA1wK58SftLo
	sk56hKkxhS6Oy0fpdeHJUmp95hTjd/DOLkgnVYBgy/V8NK1DvVywQ==
X-Google-Smtp-Source: AGHT+IFavmrB+zlPYettxpKS7DOPfDiiCUpIz3v+k3zHxlmRJMzAj0T/Eh+b+F08oXrOkwTfciYAFg==
X-Received: by 2002:a05:6871:68c:b0:288:c383:788d with SMTP id 586e51a60fabf-29720c37be8mr4067013fac.21.1732292213654;
        Fri, 22 Nov 2024 08:16:53 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f06976585esm436958eaf.18.2024.11.22.08.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 08:16:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring/slist: add list-to-list list splice helper
Date: Fri, 22 Nov 2024 09:12:41 -0700
Message-ID: <20241122161645.494868-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241122161645.494868-1-axboe@kernel.dk>
References: <20241122161645.494868-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper to splice a source list to a destination list.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/slist.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/io_uring/slist.h b/io_uring/slist.h
index 0eb194817242..7ac7c136b702 100644
--- a/io_uring/slist.h
+++ b/io_uring/slist.h
@@ -85,6 +85,22 @@ static inline bool wq_list_splice(struct io_wq_work_list *list,
 	return false;
 }
 
+static inline bool wq_list_splice_list(struct io_wq_work_list *src,
+				       struct io_wq_work_list *dst)
+{
+	bool ret = false;
+
+	if (wq_list_empty(dst)) {
+		*dst = *src;
+	} else {
+		dst->last->next = src->first;
+		dst->last = src->last;
+		ret = true;
+	}
+	INIT_WQ_LIST(src);
+	return false;
+}
+
 static inline void wq_stack_add_head(struct io_wq_work_node *node,
 				     struct io_wq_work_node *stack)
 {
-- 
2.45.2


