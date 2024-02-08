Return-Path: <io-uring+bounces-584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F80384E7BA
	for <lists+io-uring@lfdr.de>; Thu,  8 Feb 2024 19:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEAE51F2C623
	for <lists+io-uring@lfdr.de>; Thu,  8 Feb 2024 18:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99E62556D;
	Thu,  8 Feb 2024 18:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sjF1HrDY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BED2033B
	for <io-uring@vger.kernel.org>; Thu,  8 Feb 2024 18:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707417171; cv=none; b=c9akIID8iDis1obJ0LRWMJJY8AmD5uY7STS3tCnLX3GNMsIWFbgrU76eiip/Zvu9oK0UHVr1gZkCLDeMn4UDgVNZNn3umi3bSstmhWRdg/ZBJsTwzGY4f/Vu+Nq6YCgTNY1IDPKJVtYtaG1zhkVzhzfJxk9y/Ekq1sB2T76ALcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707417171; c=relaxed/simple;
	bh=woNnQGq8KF73U0rUgmmvSqIGXrgJUS6t/kmFbP8Hyh8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=b3wdhjkOrPhd66joR0X4mInjHxxvb83mcSN84vqaUxsXqQiosgwmqMETn0g9B9506V1zqYK9t5U8EuMZkixu51dKT/9NA5PYhsWBlSz7ANBSNs8vTGZR7wU+5hh7Pivp2LgDaTHHkV6DXaTAp2z/DFutB0p8lQxfGLyuN7OVRDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sjF1HrDY; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso754639f.1
        for <io-uring@vger.kernel.org>; Thu, 08 Feb 2024 10:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707417169; x=1708021969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X6dtiWjV75xos+bwFCftGuaDZ6uwiHOZu2lkmp/4iss=;
        b=sjF1HrDY8sG/gMilcrcBWyxaMky6UUfV81BEYiudnHKBL6eFpeO3euujDrrY4+h1Mc
         X6smgf3AL8bjCIo4TAM4uCmlLa+1rOYt8WCCG7t9XGOc6JHHASpYEVYtpwy0CYOd06x2
         6JE1iTQPcFEFgU5Tbarr9MmHd7IAy0CTFgM4NsB2jgupOg+D7jxSoufYgCj9RS3w2G18
         CYzV1opRh/i6rU+V2XJY2eS7jfAh8nhykIb6gqBAym6LCOWjSbrocct4AFKzCsnJZVXg
         x11UGMtSgBdAk7Bkoi16ssJ9T214JzQYNmyYFc1TUOyYCx2hzi+ei6NnNezsnV8ukL1d
         sFFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707417169; x=1708021969;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X6dtiWjV75xos+bwFCftGuaDZ6uwiHOZu2lkmp/4iss=;
        b=TmpyVbKMneVuYLOGWWaSTNUHpptl4gWgI3FDT00pXXpy2KOGFdaCtPG9IxpJ2L2YnB
         zNLmyjGVjIm5DkWFaAYYX9C3v2lxxK/cGmBq8o+GRgDW7eNmgTPKy/G7mMnlchXlEkPP
         cZUA3tnyVoEv57HuWf1DppLwodoHkEU7p4cKQj/DPqnlG+KJrOaDJsssnWa2AX7cmLfL
         ZvdWewW0JTfUyBhn0MyOnH+Roo4M/HcFjoG+KkS6MG63CTaI3FCDFfc0pP+fPtid82SU
         pt6MX357BG/0MC1drQyNN05niIbWAhBXu2KJ8CRUmd3bKNwEH74XzhmLc76hY5pjyu0z
         qOTw==
X-Gm-Message-State: AOJu0YwhciS2Q5aSeDxRgRuvYZGLUJ1yqwZmcVo1lglzfyEQgOx4l0dk
	dz8H9lzkNbG/3nkAPxbanFk+2RfuG7wFLobRvnAa0MhS2+QoTJW9hOS9qiTcMFE=
X-Google-Smtp-Source: AGHT+IEQKXkAiR5J5W5468WwCC3LL3QIPk7bvGywaj7Fg8ctV7l13AgBaBz/5zKcIZpzmTfI1HVmLQ==
X-Received: by 2002:a05:6602:164b:b0:7c4:2fdd:548a with SMTP id y11-20020a056602164b00b007c42fdd548amr133607iow.0.1707417169407;
        Thu, 08 Feb 2024 10:32:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWCeXuMsAfVTxQW+tSaJD1qVAPpQddaLN2+5TiqhcQNeXDacDlN+e9re8GAQODK73vOqbSsXdOhHxuF82rBUbVQQvpV7xkWES9bTv/nV/eWljgJlu9XIuBAMmKwfTUIwAU=
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t13-20020a6bdb0d000000b007c3fbe781f2sm50823ioc.5.2024.02.08.10.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 10:32:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Kunwu Chan <chentao@kylinos.cn>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240130100247.81460-1-chentao@kylinos.cn>
References: <20240130100247.81460-1-chentao@kylinos.cn>
Subject: Re: [PATCH] io_uring: Simplify the allocation of slab caches
Message-Id: <170741716788.1391883.13253521338686491529.b4-ty@kernel.dk>
Date: Thu, 08 Feb 2024 11:32:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Tue, 30 Jan 2024 18:02:47 +0800, Kunwu Chan wrote:
> commit 0a31bd5f2bbb ("KMEM_CACHE(): simplify slab cache creation")
> introduces a new macro.
> Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
> to simplify the creation of SLAB caches.
> 
> 

Applied, thanks!

[1/1] io_uring: Simplify the allocation of slab caches
      commit: 898e3028588e3b6d789774af623d419295c75257

Best regards,
-- 
Jens Axboe




