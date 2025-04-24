Return-Path: <io-uring+bounces-7703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E64DCA9AD75
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 14:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8CE33BAA40
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 12:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26D8027055C;
	Thu, 24 Apr 2025 12:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Fn9CKy71"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B18626FDBB
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 12:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745497870; cv=none; b=ELh8TGXP5JibzZw3X1FV8qmCZ571rAbC3s8/05p4rODAgKzEdhYbkfk5cB04zW26V2O+Iw4eZ1FoQHP/sPdobgCDU9tUQGM0MNXP/WmRzLgv3Bxn0X7eg/RwPg3RWOJfUQ1mQP9zxLvQct9D4KiupWevDxV7KVtY3g6MMdWY6UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745497870; c=relaxed/simple;
	bh=JUIOTl/KV7gCe4grWkqH2vDrhL0ZJMpH2eAgUDF/AiE=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZYxU6uZ6/Cf5NZkie+oQFWqg974O8/hf4Bt2CbtIjJw+utyt8nNQYdR01xUeSWXJQYeohigf+mXDCIa7rv99KXKNq33WrbZQV756AkOGYBqrdefphrOIllaUHMMmb7i09R5vVKGOJi0klvD2sXd30qiPUEXbFheT1jRPTQYJM78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Fn9CKy71; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6063462098eso676473eaf.0
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 05:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745497865; x=1746102665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=npMIW8ucfh1ZhjXqA3tFn73d1MmGNCbjJmR97DijqGY=;
        b=Fn9CKy71upNoh27zDvgtu4OYILHZ3mFokIXeNGRhPNJobQNlD4dDNS/oY9r/Coipz9
         xwNTCp3n7mSdIX/fuX94pfx0S7q4TQaLpTohWAjLfmEcZZcT72iLjs1Seaidr1QAVBHO
         g9+hIKzI/Up5P2ZJESDVDW07dyIfoPubJbSOlQXtdpPHO/rPKKMlySYYMO62oWAPWhS/
         MXw7UrmyJZospWV5DdnQhGditdQE8T3WdzTangra8KjC5oCjDW+prPpa0FREfsHj3omR
         sSCX2wyG1OzlGcsxx61+hhl5DwImmgAW1aMLzkfxRRnQG/oEPFMUG/OSuNZvwoX21CT5
         lKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745497865; x=1746102665;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=npMIW8ucfh1ZhjXqA3tFn73d1MmGNCbjJmR97DijqGY=;
        b=VWxZdc78m0w+il7LM7XJcj2mVh1Xg7H3Rl4/srh0smueXiI2VW2rnO/f/guFuILlSu
         zle9oXQ16wU+s6F/3DPAICYXL+NaGjFMGF9CFMEBQNE360Ze/qBf0lXo4K3qGf8TTpbh
         h7QldlhFgmZaA8KWwNSFKebo+heVql7gV8v3KKw4RPxPFrJZh5x39O7SQXhngcos5+di
         QFYgPZSoawfJU82J+ytdPcmmzsX2WHqePgwTX91YeyIqSI37WzQ+QL//4OKIk4VoAei3
         bVU4DuHYu8nEROz1AHgpelTVTGYrWMfQJ70gMjUf9+E3xwAnwe1RrZkpXvosRvsy7fGo
         xckA==
X-Gm-Message-State: AOJu0Yx94OmI7D9wmIitUPmYdILaRWHcGJAzjAr83No8ziknTgI945IZ
	7DdhD8/CcfhX9ZId81DE9OVlFyX/nvCVWGfjfVE7bY3xndftEEEjmQ4CLvtDDNYAOieoJx7uPpb
	E
X-Gm-Gg: ASbGncss37VkMtA0zS8PmYpzS+9HThczDvA3twmGYz79yzfHk0Uzckf7I5R5uQ8W7pV
	IwvWNVrN4d3Z+C6ChMVvgKsOOvgdfxMvGqiDXC7FCPF2wc6T+gWXRFjMY5RHpHygfi/DSzOalUN
	YMQ2nl8llisJgF6HH9JsufJDbJrQyItSXgA/JK4PzFcl5G/klgu+KXJ3Zogil3ehasIF7FADZW6
	pH32uWX0Mtw3C7qFZ+275G5X1ZV8nOMxkUJ2KzWhbA8Zf/dlHkD7OXOzEJpxIl1hX3MBPezkQrx
	uzXKUF2KfMDpK5h+o0i3XZD4E9IJIQ7U
X-Google-Smtp-Source: AGHT+IE9ALfA2wYvi+NZABtRVHAD9seAqJandNLBs8GYa4Dyi6onK3oMFkoBoedaBOjmYe5709ebmw==
X-Received: by 2002:a05:6870:c6a0:b0:2d5:4d2d:9525 with SMTP id 586e51a60fabf-2d96e20e541mr1402282fac.8.1745497865556;
        Thu, 24 Apr 2025 05:31:05 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f8249f8c91sm259639173.15.2025.04.24.05.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 05:31:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <41c416660c509cee676b6cad96081274bcb459f3.1745493861.git.asml.silence@gmail.com>
References: <41c416660c509cee676b6cad96081274bcb459f3.1745493861.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: don't duplicate flushing in
 io_req_post_cqe
Message-Id: <174549786484.628784.16551665130924213640.b4-ty@kernel.dk>
Date: Thu, 24 Apr 2025 06:31:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 24 Apr 2025 12:28:39 +0100, Pavel Begunkov wrote:
> io_req_post_cqe() sets submit_state.cq_flush so that
> *flush_completions() can take care of batch commiting CQEs. Don't commit
> it twice by using __io_cq_unlock_post().
> 
> 

Applied, thanks!

[1/1] io_uring: don't duplicate flushing in io_req_post_cqe
      (no commit info)

Best regards,
-- 
Jens Axboe




