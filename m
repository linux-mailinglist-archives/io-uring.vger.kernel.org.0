Return-Path: <io-uring+bounces-8502-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35839AEBB21
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6C44648328
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A0A2E92D5;
	Fri, 27 Jun 2025 15:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UW1pWLaM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396082E8DE9;
	Fri, 27 Jun 2025 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036966; cv=none; b=Ps9Gv/wrhO+SnmEWuPdsr32C0FDKOsbBLvgqskXnyIvZfgGuJAOTKKXYVjmr7ENx/zGQ7JcJixo9H+bZH6YyE2cEHMWMhA9NCodsd8epvPjJ+RHRT38uyO5XGNJmp4UYUWLmmYvonxVEChiruMBjP0ySreMWOFrmugDTr+SqQVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036966; c=relaxed/simple;
	bh=TkefzfJ/DphfEwmk+xkP0ciIPjZ2nQ4ZkuEc6BJoR20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRY0IDtRls4cjQ8qluOzC8D7RniBfcDcKqXNSUc5YU36G5uidQsohk9wEj4mlnDod6jNpw6cHMa9PWayJ2wXrvWebpVguWuJKbUayXqhg73aLEMIJ1b7Q+WYBTHZqMpj8Xg0NOvFLj3ZQTpetIDkssVdn3ge6YWPlIdpKaFFkH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UW1pWLaM; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ae35f36da9dso125798766b.0;
        Fri, 27 Jun 2025 08:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036963; x=1751641763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FTGNiKoQbsEbQ4VSKu14TwByPsQaFPpXQPix7APqu0E=;
        b=UW1pWLaMH08VeZoKWjStxCxFOKjm8GrtCwYUTspTF4mvp6+ZWtOXqZHDnkRtriECrT
         l80v0S87rAlG127/eH5669VJ39forFJdMz8YO+XhIGLQBty53AKhG05H0CzR4fkcwXkz
         rcejJ8VewMkFKfowKJ9Za6HkvLAzwVGZPNtdg8fMy+x79VPCeMCeXz3n7XOf9fWdzvQs
         1C/YntcmKrh8PG+tgcgTmatITtX/8GkSBhDKvfoBjzgYRXNT1YHmhvZ3GCKlgJKv7rjj
         HsZSlwNUFG+QT7lnJ3OlEx9AY+9NvG5/+f45/dTYkw30qpWp6blkITUYKkbjUwuHGJgj
         VUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036963; x=1751641763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FTGNiKoQbsEbQ4VSKu14TwByPsQaFPpXQPix7APqu0E=;
        b=Dk2DttnHKAaR+ewI/w+g1PGezCQpUO1HO8RRAZpCNbFQ9VjFOK4h8gvis79vdA7zwh
         HoaJCDN/Pts5NAT68xMYqd8Oa7rY848aA0x7YOFFa7g/QYKYD0W2QrihYjt0+fBeG63F
         9oiQ7h/qG6MADV+oRXLudrNloSncZQR8iDrJAMspbrkJc2CJNVdOarG2ieq7SkoaWzwh
         Jc/VFiNq5nMb+ncsX294J6/L26MellFTRg6DeBLsn8r6CoduTGjvyIozn1SqIq0smVOq
         hPQbIt0veQQ/iaPqat6rdroZYRFipRgyJ4OyaoWxYE3ZYbI8Emo7n8+3RYN9scW6PYgQ
         /lqg==
X-Forwarded-Encrypted: i=1; AJvYcCUkZ5djND5CCtSeIuTy5nny0zDG5BI2rPFzyOOlQuBWKdE8OBekAD6CuckuINi/rld2Wc2ucX9t8nsYzg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHbbpOcoKjBExZ1kl7Q0/p8UCaeAL+HrRndCs5kSE84HUXaHew
	Fla0NICtWs9r7Ze+ub1GNaXZv4BHHx8LbzlBtWE4EsqdIEG1e+6WhRfvcQDdug==
X-Gm-Gg: ASbGnctoTiBE7Macz+tWbIcepQrL5uqmkXeA98m7S0DyzBqmm/yPQcyxxpXTEVOZXpG
	3+oTTHkdifDHqzm1tWWL6UCRWQDg/MtST1ZIuTN6EkZkcYrLvDC7smfE3biCcN6/1up53mwPHJm
	JXd5fNNuGz5Dob5FOPmleEeFgUPI2WOCzIHBsbxLOc2tnJZzfnUOooQZC/ZvZIZd4HURF//DgX/
	wf0bCHKGdhbEVR/FtP5XDZ3DZLsPqKULksq37oobk4Ga1xS8q7nw2PYALEC3TXBRmcJCPGQtiVj
	AuZQDN5FMKYuBbUK19rEPOSxY2dX6GKsYJJlpocxnJvZGkaVwHgzZfoU9qZjfE9rJmzCVYbKgg1
	f
X-Google-Smtp-Source: AGHT+IHddxu52eYe4GdP027a7+vbQPkX8qfQtf33mc//fGgKF8hjaVtLQZicWUAm2AT5vyKpmMUdUw==
X-Received: by 2002:a17:907:1c1d:b0:ad8:9c97:c2da with SMTP id a640c23a62f3a-ae35013de6emr355935966b.40.1751036962582;
        Fri, 27 Jun 2025 08:09:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 03/12] block: move around bio flagging helpers
Date: Fri, 27 Jun 2025 16:10:30 +0100
Message-ID: <8621d50e186a9a10dc98e5aa7834e286612522cc.1751035820.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751035820.git.asml.silence@gmail.com>
References: <cover.1751035820.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We'll need bio_flagged() earlier in bio.h in the next patch, move it
together with all related helpers, and mark the bio_flagged()'s bio
argument as const.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/bio.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 9c37c66ef9ca..8349569414ed 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -46,6 +46,21 @@ static inline unsigned int bio_max_segs(unsigned int nr_segs)
 #define bio_data_dir(bio) \
 	(op_is_write(bio_op(bio)) ? WRITE : READ)
 
+static inline bool bio_flagged(const struct bio *bio, unsigned int bit)
+{
+	return bio->bi_flags & (1U << bit);
+}
+
+static inline void bio_set_flag(struct bio *bio, unsigned int bit)
+{
+	bio->bi_flags |= (1U << bit);
+}
+
+static inline void bio_clear_flag(struct bio *bio, unsigned int bit)
+{
+	bio->bi_flags &= ~(1U << bit);
+}
+
 /*
  * Check whether this bio carries any data or not. A NULL bio is allowed.
  */
@@ -225,21 +240,6 @@ static inline void bio_cnt_set(struct bio *bio, unsigned int count)
 	atomic_set(&bio->__bi_cnt, count);
 }
 
-static inline bool bio_flagged(struct bio *bio, unsigned int bit)
-{
-	return bio->bi_flags & (1U << bit);
-}
-
-static inline void bio_set_flag(struct bio *bio, unsigned int bit)
-{
-	bio->bi_flags |= (1U << bit);
-}
-
-static inline void bio_clear_flag(struct bio *bio, unsigned int bit)
-{
-	bio->bi_flags &= ~(1U << bit);
-}
-
 static inline struct bio_vec *bio_first_bvec_all(struct bio *bio)
 {
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-- 
2.49.0


