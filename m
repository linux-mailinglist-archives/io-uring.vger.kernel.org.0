Return-Path: <io-uring+bounces-1458-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CC3789C6FF
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 16:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 889731C215AD
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 14:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516CB1272BF;
	Mon,  8 Apr 2024 14:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eHSouZ11"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41086A35A
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 14:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712586275; cv=none; b=X7OpktIYaSyBblZ0S/8ykqfFSlqpaaZNw3fDWIzgkNbcR+2kOrUeceKI2RX7fLfaTI54QSnDjxCTRqtF226gelR+W0OqvjITHsmQpdnWnxEyIPWKEndORx8YU2+NirOXFt0XMKCEut/BUUdhGrV4Mm7upZjR3ly1SYqu7rGlODM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712586275; c=relaxed/simple;
	bh=8igI1nCR9VPkvN9N0kFH217ct5NSfF+Vdzv7w7dAjQs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gnn56hu10+53P6j8wPn6AwyHPMdSa1KmH/Hpjta58uaFk9EBHgkAraqyRY90NEMfA4QNST6lGMOD+k5kuHGQLqxL2WffFJrt8rGEKdrYoSsiMI9datiBAK/O6gm7EELKMQPGrc+J7UhtBZAuG3qZitzKEHjd1G7hhDUySvKv+ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eHSouZ11; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-56e2b3e114fso4053247a12.2
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 07:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712586271; x=1713191071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/C3LQJVsW0kZNPfX5CTRMN2cuNUmXG3FtWfvkh4GeAc=;
        b=eHSouZ11FS4zVIQa7zCvmFgeXij3egFWfZPWfglABjijpxBjGTDyXrkOUnFE5KsNAL
         ouitb4QbNO0WWe4DCnDXVK3DyXX55q0YZ6pYZ6IvrmpKn2wejdMcl/m8yHMTrzJIoeih
         N+c3yZHTGSioAbrG2gkyVxZc+udvUjrNOiV4G+fdoIMQc4Ojk8WqkDmxPragtNMwV8cY
         VLonWemVYXpCgGNqjxz+9IJP8+EGU9QmlMdsPIjyCYL/TLNiHQZVHy1gvjTje/FE6kzE
         3xKHRZytbwFN4FRb9gi1i0uAIgf5zZjXhO4LB3MqDHepVw2NMA1PY8eTZUqUtMB89dUm
         UfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712586271; x=1713191071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/C3LQJVsW0kZNPfX5CTRMN2cuNUmXG3FtWfvkh4GeAc=;
        b=GodE3AAL9x4fejUs5qPmSeDwLBTVsvYGI99JKqiLXfiFkaqhs0Q8Fzf2+MLe4xVa3x
         A66zICwnnmmhXprGCeI2W0db//wJfSdBlYD2hr1vPSILdZDoi/r99Jvjzklhg5qUTgz1
         jO1tDs4QTSRJ9z1wpHKBphfwdyG3ZakeJnqB8ta8uePqrmFel5eBVxvWXlj0y8R+/BPV
         34C3aXGjVWgcolSWejnyiIWE1u8wXf5HZQgnJLQ0Xxvnd/PcEofHagxtcA6Yi2Awt4VL
         f+vwhvYy/lBWS5kFbhR/K7Xz45N0vnsLW5qEcyN/Xjjcjqp/S+L1lVs48cZlvOAWavfK
         VZVg==
X-Gm-Message-State: AOJu0YysdyuA8w9Q4r6GMzGSaYz8X864fgUpIoTAH1GQxrHqZdsrAm7H
	Dysq0OUhYbPSEr0nkqN6DLj/Zrp7tnaYM+2/1g2lS1s6GWm6S8uTvhJkuobb
X-Google-Smtp-Source: AGHT+IErZohRdlCKjCF4HY55x3/xMj/VuoppeouMPzEo2KRQnok4qrkrYUIx7VLtOLi8bHtlZCMq5Q==
X-Received: by 2002:a50:c349:0:b0:56d:f99f:a600 with SMTP id q9-20020a50c349000000b0056df99fa600mr5971388edb.17.1712586270772;
        Mon, 08 Apr 2024 07:24:30 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id p2-20020a056402500200b0056c051e59bfsm4215931eda.9.2024.04.08.07.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 07:24:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 0/3] improve sendzc tests
Date: Mon,  8 Apr 2024 15:24:19 +0100
Message-ID: <cover.1712585927.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is enough of special handling for DEFER_TASKRUN, so we want
to test sendzc with DEFER_TASKRUN as well. Apart from that, probe
zc support at the beginning and do some more cleanups.

Pavel Begunkov (3):
  test: handle test_send_faults()'s cases one by one
  test/sendzc: improve zc support probing
  io_uring/sendzc: add DEFER_TASKRUN testing

 test/send-zerocopy.c | 331 ++++++++++++++++++++++++++++---------------
 1 file changed, 215 insertions(+), 116 deletions(-)

-- 
2.44.0


