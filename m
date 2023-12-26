Return-Path: <io-uring+bounces-361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6110081E86E
	for <lists+io-uring@lfdr.de>; Tue, 26 Dec 2023 17:32:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04A55B21A9B
	for <lists+io-uring@lfdr.de>; Tue, 26 Dec 2023 16:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08D94E639;
	Tue, 26 Dec 2023 16:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nNoDAqAr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463D51E493
	for <io-uring@vger.kernel.org>; Tue, 26 Dec 2023 16:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7ba9356f562so30715439f.1
        for <io-uring@vger.kernel.org>; Tue, 26 Dec 2023 08:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703608336; x=1704213136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnzU4WJmQxmkUC7bQNo5RhC0emWFKZu0JZ9NLV6mjrw=;
        b=nNoDAqArTCsBjQa8myfnZiluXBclw83OvSNqYUgvHtNm0Z3ZPCoDtq9x1LeOmyy80Z
         lUacv05wKoLoD4W2crAZd31whxR7p2zKo2XAV7p2HLVp2zdSjdbBh4hkqdSf2AQTRIBT
         erHtHBTnrsygHLzZavBAygOEzJXgbzC093NFKO46bG2+D5qPWlYTPC1OWE1NqfUUPxgL
         mAy5rU1dYtKIp0+bAnjJXpGeuEgWkg7GrZ6HVdBXntttFmZffPRsFMjk076jvymdbyNP
         70UOmSrRaGylwRcDV1Fh98yTMfUpNS1vgfxn144FB9T0FRyzXsSiyctmIwyR9viPOFOe
         0lbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703608336; x=1704213136;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rnzU4WJmQxmkUC7bQNo5RhC0emWFKZu0JZ9NLV6mjrw=;
        b=kGyLq8MshHdphBO4FEwYf0ixt4ILa2g0G3F+bqzOaaJQ2b5HfOSAEtrt/JK0dMOEmy
         MR3zQU6jSLrc9WqfhrW5sRl6nUq7226i26GbSuIePeZWrZX1beUGbv0lC9lUM5tQC0Fk
         QfXo94CQ9nevUYMnTuHwAIu/cGztZWtbVsTIFqfDm9A9b5lBJw/65+yznat0TOnnGrtx
         zmtDmWjyHJqbRmvX0Bwud2bY91WVZoEuzsZ0PQuICbgYJ+mnQn7CmqcTlZe7YwlbLQOU
         UUWjclSQlo0HpyLIrvgEMSpFWWeW5JkSoSBPCefh+sWuptxkm8CetoNo6yRqBuMxmLiI
         C1Xg==
X-Gm-Message-State: AOJu0YwPO4PF5JA/rBKRLY7dbdgUwBh99TMIgM1pv9lyRQwM70X5qoYQ
	AwcUYX4KiISptUHi0RxXEeGSvSPhQj5zwg==
X-Google-Smtp-Source: AGHT+IHoNkKVl94LC8Wx0njrXqNfmcz/RkWU2KDFwE5BRUwhMl21Wyoe41r6NIPjLq7PoF9EIPI9gQ==
X-Received: by 2002:a05:6602:179e:b0:7ba:c855:9cf7 with SMTP id y30-20020a056602179e00b007bac8559cf7mr4948137iox.2.1703608336402;
        Tue, 26 Dec 2023 08:32:16 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cq13-20020a056638478d00b0046923416e7asm3197603jab.175.2023.12.26.08.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Dec 2023 08:32:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org, 
 io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com, 
 joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com, 
 ruyi.zhang@samsung.com, cliang01.li@samsung.com, xue01.he@samsung.com
In-Reply-To: <20231225054438.44581-1-xiaobing.li@samsung.com>
References: <CGME20231225055252epcas5p43ae8016d329b160f688def7b4f9d4ddb@epcas5p4.samsung.com>
 <20231225054438.44581-1-xiaobing.li@samsung.com>
Subject: Re: [PATCH v6] io_uring: Statistics of the true utilization of sq
 threads.
Message-Id: <170360833542.1229482.7687326255574388809.b4-ty@kernel.dk>
Date: Tue, 26 Dec 2023 09:32:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Mon, 25 Dec 2023 13:44:38 +0800, Xiaobing Li wrote:
> Count the running time and actual IO processing time of the sqpoll
> thread, and output the statistical data to fdinfo.
> 
> Variable description:
> "work_time" in the code represents the sum of the jiffies of the sq
> thread actually processing IO, that is, how many milliseconds it
> actually takes to process IO. "total_time" represents the total time
> that the sq thread has elapsed from the beginning of the loop to the
> current time point, that is, how many milliseconds it has spent in
> total.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Statistics of the true utilization of sq threads.
      commit: 9f7e5872eca81d7341e3ec222ebdc202ff536655

Best regards,
-- 
Jens Axboe




