Return-Path: <io-uring+bounces-416-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C44CB8308E8
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 15:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 617EC289452
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 14:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C7621343;
	Wed, 17 Jan 2024 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XpFei059"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B167921355
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705503566; cv=none; b=JWe0idijKrGiLUnOIzTDSiZmSwlWrz2jTR9TZ+XWIw+EOU+vl8zEtcMBpJtiubTh/942NHa6EdTNlKwGP2ku1v3enlLuYVQCm8DFXKgpRWU6jwlubQ9S42E1kjMeuIcp6aZBqS6E+jS2ugKmFy+BrLA8/qgvHRwsbBIhmcUi6MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705503566; c=relaxed/simple;
	bh=TvCwUPP7RgRA2EHvZPRYHr8R1OJHjIDEPb++udd5oQQ=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 To:In-Reply-To:References:Subject:Message-Id:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Mailer; b=ShBuTxGmVdpvQl1Nf1l0wlCMtQdg+fQ4AGqy58tllxoWAJjCToNkUByBwmdsiw7rDzITcBtLeTZh88viWEhso6uAI3g5YSP1eiy/uEVPnny5bT3jt/1nMTN/V9zHOFbtpibcCBCKHPgDfwnQTcAmvQwl4Af+J8bTBzfiluslDhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XpFei059; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7bee9f626caso56177439f.0
        for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 06:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705503563; x=1706108363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TEyPQjCu7oZrDVWgL6o8E+/GYPc/U6bHgZRrcESzM2E=;
        b=XpFei059Cad8OVZxdivOcf5W/Rq3WX+ToRKsQp5GrgNP7GzOhVfk3paaNDWyYeeohv
         u3gCmo8fF5H9axIlaO9l8G0APqBOQvs3hymoUkf5+Lp9c3fBe67+nATr0O3XJGTx5VVd
         F5eJBZoS/3pxDT4woKxfVKkmo3maf7ay/Ab0LbbXHpkXgmoTL1NJh1lUScTyyJhrV8Cn
         2Z+bm/NsAC823gwtwSDuuG4/FmQ5Ipj3W05yV4xXrGrbRI/uDTYZIFSwcmMemTW7l4VX
         AjImlHjggOsIHeMcfRrzaZaPlB123Uvon91ea/Q+U1gEYt5EArFuY4cX8DgtEVcdgpzQ
         1B0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705503563; x=1706108363;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TEyPQjCu7oZrDVWgL6o8E+/GYPc/U6bHgZRrcESzM2E=;
        b=pBzEg5cEGdwmx+wd3G+j8J8nLy+F+tJAYbtsh09cmTy22Oa07KLZjSxQ51LnUi0Hu6
         CYF8vPyF2Kh/zrdoIvaFBAK8d5Il6qE40H08DENPTb1NN8ap4vsYjMrbbN5rikGfdRf3
         SIhptDi3/fi+JtkziyRGnX8t9crX7EnHJMUceP0NyL03lsFubaKqIDGj34buypG/0MTF
         aDAJedbTp+/dnREfrVzH5bmdEWVizmb8OWUnSEKjx+8z4bW8SsW/ZZv6gdg2Zdt/j4PY
         EOesRhggs5eA6o0S9fEXit9r9YCIFFksvJuA1Y8tW50BLWGKuW+Fa5vXCwCNt6ux+dpo
         L1cQ==
X-Gm-Message-State: AOJu0YxmT2ZGrOqa832DKAq4xBjYpR2bNZWD/EpKp0ZCrhtDE+iHkQgx
	aDf6QqfYL0gudNF+2MEZuIXZlvLUBpQznvtrnyKh5UZfcXv0kA==
X-Google-Smtp-Source: AGHT+IHtekEZEpUIc5nARCDGjLM5y8yRST3res8xPnjCmyIWdmFwh4c6uls3bywVZ4wIW3IUj0LmRQ==
X-Received: by 2002:a5e:834b:0:b0:7bc:2603:575f with SMTP id y11-20020a5e834b000000b007bc2603575fmr2313560iom.0.1705503562029;
        Wed, 17 Jan 2024 06:59:22 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y63-20020a029545000000b0046e77bd393dsm469336jah.144.2024.01.17.06.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 06:59:21 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1705438669.git.asml.silence@gmail.com>
References: <cover.1705438669.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/4] clean up deferred tw wakeups
Message-Id: <170550356144.580014.1696169787529564172.b4-ty@kernel.dk>
Date: Wed, 17 Jan 2024 07:59:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 17 Jan 2024 00:57:25 +0000, Pavel Begunkov wrote:
> While reviewing io_req_local_work_add() I haven't found any real problems,
> but there are defintely rought edges. Remove one extra smp_mb__after_atomic(),
> add comments about how the synchronisation works, and improve mixing lazy with
> non-lazy work items.
> 
> Pavel Begunkov (4):
>   io_uring: adjust defer tw counting
>   io_uring: clean up local tw add-wait sync
>   io_uring: clean *local_work_add var naming
>   io_uring: combine cq_wait_nr checks
> 
> [...]

Applied, thanks!

[1/4] io_uring: adjust defer tw counting
      commit: c5121e33d343f1febaf2098d413a5ddfcaf5998f
[2/4] io_uring: clean up local tw add-wait sync
      commit: 71258398c2b829457859bc778887bf848db35f50
[3/4] io_uring: clean *local_work_add var naming
      commit: b67eaa9683e2a8fea427a4be2603c0f79416407d
[4/4] io_uring: combine cq_wait_nr checks
      commit: 06660b62dbaac1e5170f73b866d13081748d38d1

Best regards,
-- 
Jens Axboe




