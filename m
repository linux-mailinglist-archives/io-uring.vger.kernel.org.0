Return-Path: <io-uring+bounces-7322-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73AB4A76D44
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 21:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B55418859AA
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 19:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA842219E8C;
	Mon, 31 Mar 2025 19:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vecPV4+N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C79821931C
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 19:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743447998; cv=none; b=SuOXHnM38mUwZa2Yr/hVo+LWKtneUXCFfPqLBCb5RyPt330Gnmh+ablz+HmXVBYw1tCj+SVgZtKZSerrigL+8KhJRBPdXhpPcD2CQ+0DvnwTc1L0IRbTNMxV1PS9//lcibePjyAVGdx8kvNr1PaDyxlxy0l8XSKcgtOMRg1vEYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743447998; c=relaxed/simple;
	bh=R6HoO9utzNAyt23BET7OrJlz4hwYGXX+QNpyGY6nmpQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZPiLFKdg2Q/vgzsrk3MjP0EsSkIz5eoU7a5dJcFwksHLbEnvGoW8S5Ma0EX0ef75aCDGh5O/Gg8nqMiAyoQ/vnoUU7PVlrBBUvSfjITW7wY8vTzQ5ixutUgIMgoOcsbEAGVDRb0/z/HA4C+I8b+FUgbTGfXaPUp4wHfOLCVKNBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vecPV4+N; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d46aaf36a2so40216285ab.3
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 12:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743447995; x=1744052795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HdVyUczeJWic0WGQFRDHoRFIuz1e6rkv6Z0rZI+fogM=;
        b=vecPV4+NcjBKZxvci09ryChOORKh/n/VMIf2ER71IkShBfT/FNy+Ai/PmNuUWS7YsR
         JWyOOVs1lEZaQ584VdEjgmh1oX9M2v3j7KVDDjOYHZaTcvaclcdyokQqPzKii9bkS3k9
         RbEzjTfjHJy7RWFp6E+1W0V9VGIUbBxa+VutQdsZExmJTmr9xdjKzleliAedORnbpcqH
         m2xKvQMXdS1KP+VD+dEFIrxq8Motc8xpIS7A24WSZWhUvvfVLbaGRg7A+/G5h6Ixnp4u
         ulCwylZD0/0kLpxwgiqAbALs1bqk9aqTDdUmTHv36V6mmyWdf1ckFx55shPakKGQNb4p
         PiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743447995; x=1744052795;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HdVyUczeJWic0WGQFRDHoRFIuz1e6rkv6Z0rZI+fogM=;
        b=fHUV/Izln/uvBCx8Lc36CiMnsRU9sYtuUIaz5Vg/0RpvUx7PRVYUgl/9fbl6Oy8J9V
         a4uWKrbSfHvYLqsBGqYj1VrXcgOBHzkYj5nI5mb8YhjyQ9xNbIBwlylVidGpFuWo0QoK
         lZNwwSGrit018BIB+JI9F5r4e/aIIN82UEjOLyM09Bbr1o48gVeTrItiXDBuI8BvXYNU
         K42kn9vIqv5M/rfBnOuqZAu5VTafFteOQW7GqKbz6zi8kZCoWgSaXOjEYrXLJ3lnUkI8
         OkLqgna4NRFi2LqGBcIjNqUI5QLI+znXaQvQ1aEDsm0zk8Uw0aljJbMtBw+N4hviO5WU
         gOxQ==
X-Gm-Message-State: AOJu0YxoU4zWnfjfbeIn+WAH798QgB3/XSd7hNV79ieoOH1vOhA98fVM
	DMbQJaIP+fM04nWqTtV7Lk7hTKPw7QGpiLwYGCHHhrdmEvujO+SL5rEnFHAr5WU=
X-Gm-Gg: ASbGncvNEWw1VIH+RPhGqavpa1NGAGlzsCVutF7w7MhCkPwIqNMEIjk9xqS0w0/ywxf
	n5tjgQnCzkfCoSlTjazQy54hTG/tXsosZHsm5nLdpINiD5CrsLvmgVWq1O4JPKPcdStxt6NRnLJ
	fjY2xRAd7kymbhXYf6enudreyKfYyyUV55tHO/5zQR1IKHwS3qb0D8aLFQC7KvMTPraCo7nTp7G
	vPPTVLbyeqJGaoVsHbmZln7SRq2GZUCdYHMjISZmiogX1Y7d9+Hfq+k5N0U7lT0NkuRSst1z1QK
	CZPuySnM9MGLltagAA9AbqNYZMpHjfdJrb2v
X-Google-Smtp-Source: AGHT+IFsxImJWmlzj0bwdAadBWG5vlsc90rZeFVRrBs5cjWqMGjs0KMH/Ata4U5Tofg9/H/MTEKVUg==
X-Received: by 2002:a05:6e02:164b:b0:3d4:244b:db1d with SMTP id e9e14a558f8ab-3d5e090720amr97784525ab.6.1743447995215;
        Mon, 31 Mar 2025 12:06:35 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f46487193dsm1995145173.79.2025.03.31.12.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 12:06:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250329161527.3281314-1-csander@purestorage.com>
References: <20250329161527.3281314-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/wq: avoid indirect do_work/free_work calls
Message-Id: <174344799393.1769197.3886261668995690740.b4-ty@kernel.dk>
Date: Mon, 31 Mar 2025 13:06:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 29 Mar 2025 10:15:24 -0600, Caleb Sander Mateos wrote:
> struct io_wq stores do_work and free_work function pointers which are
> called on each work item. But these function pointers are always set to
> io_wq_submit_work and io_wq_free_work, respectively. So remove these
> function pointers and just call the functions directly.
> 
> 

Applied, thanks!

[1/1] io_uring/wq: avoid indirect do_work/free_work calls
      commit: 842b5d5f87039d978a9748f8728cabe07a676252

Best regards,
-- 
Jens Axboe




