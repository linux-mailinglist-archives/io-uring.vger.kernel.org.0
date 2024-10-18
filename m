Return-Path: <io-uring+bounces-3823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC2C9A45FE
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9B7E1F24600
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BF92038C8;
	Fri, 18 Oct 2024 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jAveP8Gd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6287204013
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 18:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276672; cv=none; b=S/rYZiA9ITuGBcqJNRW/JD6xV7baNX8ApHNMLVyyPbuf536kzdHY3r/gYAYaFccMNaC88utfdiNVTkTjHdq/YrSiaw3oMjJCvtUrymQu5w3k9fvi95O5DqUBomIfplYD/N6rRhMgEQbocgkVUZn0Y8ORvZcF2Mx72blhsBjgsq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276672; c=relaxed/simple;
	bh=BCuSFL79JBvp9l+9wZ+QNkkRKbHrfGUwgbn8qd4Y5kQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Q78wUqB/UAjUA657h8r4GRcUexg/3wfa+YlgzYo49wSIDjUJ9BjcResyBGOr1sGZ2jnemibiJ+NlUaPQxjEn+zNyisLH5FO0VlQHS8J+aOf+f7UipVzm5C/Euw4Z5u/DPYC04UkIACbAU2U+HuQzkwNoGQkQeI8a0mOqtRueuXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jAveP8Gd; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a394418442so8115835ab.0
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 11:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729276668; x=1729881468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jj4MvNLLj+D5FTHp+vm3MqkDbriUraYkzV+r2KRCX7Q=;
        b=jAveP8Gd8RVMZkAFozlTHgBOzZ6jZ0ufinnyy+GaW9orBNEv0T3NlE6Tpjlnz8r8su
         aHY4BvJ+huGI7IP2goUBEwIwM/kJ/rk+oQ+lCHip7UVF09dCrWpc+lJeyXmVCaXGsOnJ
         wKr0aIvFcsxpIsqcMqQOwrr/OxZlI4dfGpWzzN4Gxx1mlPejvxXxrACyV0NnSSrH0q15
         9XT2h3WIqr2r72RxC6ufTU9UXMrgfyVttKhlPHiK4vfZYSH2XGoCWt/Y6dY5F4QPppLL
         SVjXCKkhsfwxQjg2uV1n25d4MgXOp9McFPLFG1l75xINYS0Ls9XFO5PSDS8IYkXturOI
         etvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276668; x=1729881468;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jj4MvNLLj+D5FTHp+vm3MqkDbriUraYkzV+r2KRCX7Q=;
        b=VN+4lI2P7ZECuOS2telKETVWtsit5qYe2VXNW/eeIOdUglMu3to3O05lybdawZaF3J
         d5TDOqSHFy5ZvkCL2KjSKpy5NedP5rV2oPAHDDfiYF8twxorW13MEgfx5WniBxvG6h+i
         TVEgBRzN0aVe+23hIQ/xD+prnNBDdkjHQLkUhcUYDobKsiPrQRGTtRTF9kEarl230wSg
         EkAfcgI82FLaEJZH7txSD7edyV6pelVXT4GvjtzGaiu3ZvZQ4HfIyiWoq1P7/wVzkDiH
         8Z4eSnwgX/xxbFyzQ+WSAYhmElRcwb4oNSlNIquJc8ih7egoeoZx1cx2sLoAXWqAd9/3
         0adA==
X-Gm-Message-State: AOJu0YzIMD93PRzh9Fuo70+b868DskrkjcHSvVbDyz215lFQtQyOJ0Z3
	lU9fiY/dlVaexL1ceHpQubKxg0whSH31rUEvZcN0QO3IpNR9qTNIOu/UDK2rAXDeFLBxetAsBnU
	7
X-Google-Smtp-Source: AGHT+IHr1XLCQ3kRL3OqARRW/jZqMQpIkwpTuQHZipTjCbmkMXe8Utbuih0ee1NSw3FEiucK48SZKQ==
X-Received: by 2002:a05:6e02:1564:b0:3a0:a71b:75e5 with SMTP id e9e14a558f8ab-3a3f4054351mr40506145ab.7.1729276668635;
        Fri, 18 Oct 2024 11:37:48 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3f3fd7ea6sm5366675ab.9.2024.10.18.11.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 11:37:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d6765112680d2e86a58b76166b7513391ff4e5d7.1729264960.git.asml.silence@gmail.com>
References: <d6765112680d2e86a58b76166b7513391ff4e5d7.1729264960.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring: kill io_llist_xchg
Message-Id: <172927666758.464574.13355424018146131684.b4-ty@kernel.dk>
Date: Fri, 18 Oct 2024 12:37:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Fri, 18 Oct 2024 17:07:31 +0100, Pavel Begunkov wrote:
> io_llist_xchg is only used to set the list to NULL, which can also be
> done with llist_del_all(). Use the latter and kill io_llist_xchg.
> 
> 

Applied, thanks!

[1/1] io_uring: kill io_llist_xchg
      commit: cb943835067450aebf6f1171e81ea5958ce34b03

Best regards,
-- 
Jens Axboe




