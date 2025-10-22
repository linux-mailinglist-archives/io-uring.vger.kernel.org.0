Return-Path: <io-uring+bounces-10146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D70CBFE613
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 00:10:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E53AC189DD49
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 22:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD6B2737EB;
	Wed, 22 Oct 2025 22:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="t/36PsjU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6732F8BCA
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 22:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761171005; cv=none; b=O4NJMcaiZl9wKa3jl49xpJtIbUuC+ppLxRY/BO4aiO1Zb4lNPa7hrB1U5/kMVZOkWEhOwMd5pxJ2ivo05qo9LtvENFjNQlmFPA4NPgXJ5dMpTznwthx8HgQxjOBMxONhWEiuKZwfJc77is9JNArxtDv3Rf6de/a1U5/Sm9AQupU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761171005; c=relaxed/simple;
	bh=xmv8xuwGQ3nc0l67LUpUlDbuFdiUOjQwhJmCeLw3o4k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OfVGkFF3lluA/eLGhVF7Ma8OSdRF9g+5WXVtu89cJNRMmBX/iodLdhKQPZNZFCXb58R2Dk4+tJ3xnpP+0zNQN4rTVgJUW+Vaw4WRbJVPoc7EYHxd9SFxWhr1bwIIJuVqzC3bgZotx4RwRK37r79GyZ6B4nLQ9yITEdSDJ8+K8Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=t/36PsjU; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-430d08d56caso772985ab.2
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 15:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761171002; x=1761775802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQ6htWzRflK+ICGK6X/bLRh49guoXzNTV+K0TWWiI5A=;
        b=t/36PsjUsvcqExS6BZ4Iq+2OUNX1Ol11pB7WQ8Zoi1C+qAb2/LxdieRPGnEd9qF1T6
         kctbz4QwDq4W6+Yt/v/VdNaY7+9AjIjTVZiCWaHjNKuHJUhWRDagzabeQWTQDN83ryc/
         YQvuR2nikfiOkfwd7kut7m7kf4P1PtV4KtITGQlDLf11udvGxJLWOiZ9D3amv2QEGhzg
         1R5k4uaIY3hHqzdCSBU6ccYZBCGAEYhGvuIDpNmey2DkZN6URcfnIx7l4O4ZKcP4fjtf
         qyl6oq1Xve8JXOFSJYxtBcWE0xBQHdvFiSYM/8QVYJjFpulsrOaLIFB5d5vvOyaqkdWJ
         qgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761171002; x=1761775802;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQ6htWzRflK+ICGK6X/bLRh49guoXzNTV+K0TWWiI5A=;
        b=gr//j9lSg7C8iDua8x+MXXpXM8K6/jIrMVlsVmm1yecvPgvNmGuH2V3JizDh2TOkhc
         DtOho51ScUsIFGrnjwR/k2bNdDk9EUfdPhq1BD5nxNUlZu7cqU9Ep5p9SJhdgRouIqYD
         IX/vCFVsizk2VjMZraiX57o/uSnlgLmPupGlVM0jKmR7KhWwPsNLkoqJ7vJ4xZFvXueS
         pZJq0yAi0lBEx3My3u4fjYGoJbGCRwNlCEs1lo7kQN6/HB3DNZVimJAZzYtduS5fgBk6
         dssgWgF+3t0yp2cMQorb10MHqVDK/1UWQ395YQmPRa41WoqC6qMdnaBcpQMQ9SbXRJ3Z
         mYEg==
X-Gm-Message-State: AOJu0Yw1cXaAYa2lUGKk8oTA0mhsZ+5cpt1gNY+ljrzxCLcKry6Olwg7
	HIg95/OVup4a+3B10f92VulJzsIGsaEf0XTZ6IwBEeqZAq5pk1NCf1k1jTcy+HCx1Rk=
X-Gm-Gg: ASbGncuLAVDlfJo4ZWCWke6KdQ1Y5IY2Ors0ubgDo8/2VOyW6owC62zteIQS3CWXRBC
	aruWc/tlsawy/DA9L9T4gdG5XPn3KGEKXLWhH03NwBq8H/A65JHGofDwW7tF8GFFR+cUJSkvW4w
	HG5H20V8hpmVbfJllV34sJpmmu2C/z1N5KowfdfJdNWybBKVzC1Vh6N0Q88v/VaTDuZt46/GRlI
	dbsfUhf3TS2i6lDYTEYkCmEo3j1pXdweuuqJA7Iu6I3YMXdUbrzZpkrboCWy9o6oI1CbmKjnqlu
	DKcM4s6ubeaZCwyrdlWrAHjiQy0PU1FQBVUbPtflHtnSCSJ4Wkt2dpoI2eouuvZ7+pyJ0UcoR18
	7HokPhomm0LjL3WrZOy+HVOfh8O2AbIqYw4OtpyzOTJ0oexv9B8qf13hptEpCbWCCNhK1
X-Google-Smtp-Source: AGHT+IHDBQaVXxF3Iaxtt15PzMPCFh7Tv3Ywm2UUvakjMUJmiAznJVwTo2c7LbuOWoYaPTAFjxsipQ==
X-Received: by 2002:a92:cda3:0:b0:430:c491:583b with SMTP id e9e14a558f8ab-430c52367d5mr310015715ab.14.1761171002115;
        Wed, 22 Oct 2025 15:10:02 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5abb4d55efcsm126930173.11.2025.10.22.15.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 15:10:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Keith Busch <kbusch@meta.com>
Cc: Keith Busch <kbusch@kernel.org>
In-Reply-To: <20251022205607.4035359-1-kbusch@meta.com>
References: <20251022205607.4035359-1-kbusch@meta.com>
Subject: Re: [PATCH] io_uring/fdinfo: show SQEs for no array setup
Message-Id: <176117100123.172292.11432176457482807538.b4-ty@kernel.dk>
Date: Wed, 22 Oct 2025 16:10:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 22 Oct 2025 13:56:07 -0700, Keith Busch wrote:
> The sq_head indicates the index directly in the submission queue when
> the IORING_SETUP_NO_SQARRAY option is used, so use that instead of
> skipping showing the entries.
> 
> 

Applied, thanks!

[1/1] io_uring/fdinfo: show SQEs for no array setup
      commit: 0ecf0e6748120842700efc5dbf22a18580f7efcf

Best regards,
-- 
Jens Axboe




