Return-Path: <io-uring+bounces-812-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE44286E4C0
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 16:55:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9D061C224D3
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 15:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0BE67E77;
	Fri,  1 Mar 2024 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MlwjITw6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B478070030
	for <io-uring@vger.kernel.org>; Fri,  1 Mar 2024 15:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709308531; cv=none; b=RCLOI2lmOjaxn/knIGLzouu8IR8F8tzIOgCm4eKTKnJsNlXS360DR6gqhIpIuJsDsIrvZJs2F5JUnwu9TBfDGAGCKTw0J+6gxDvFFSHMFCgVuU124OB6obOJoArL7NSCjlqI5SWHCy5REe8dTIj0DgC59XSQL+CLSrjFOb8LOOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709308531; c=relaxed/simple;
	bh=zi0bk5Cs+q7geBC6wE4n/dJCyCKURk4w3ELa9Zvu7s4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UJjeY4leXsdHGptoY3Nit8F/03zw0j724by6QMu/XKWfubt3qKx92JIcWs820RZZ1oyyXJYjN4zDx923DlOar1IJHD90hJx++Tq5KGuCvpFyUD5dTq25NUF46SNaAYBbzflet+ijQ7efRFb8LPe+ChLheD9zcDYxOe2azuDHDkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MlwjITw6; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso37153439f.0
        for <io-uring@vger.kernel.org>; Fri, 01 Mar 2024 07:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709308529; x=1709913329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cAWTzafg6SPo4FfnmrTdAIG/dU4gxVOaqWTDkLn0alM=;
        b=MlwjITw6m0JYmG/7UsEEleTLmVz5r1MVBbluh6b2EUW/JaYrDFf5m7IgWVOE2xSOhq
         kNJFJEf5dZbEeJP9UhYGbmgb0zGTm98GauDHjX8igG3rQFBguS1dWH21a0IkflgzTyqL
         YpUO/EpplNDGtjGlHBtEorWZ7Crng+VCi9QsGWlrzsNUEF1oWn65RpOr4j/5B4kRtKxl
         t/puuCmY1NEwWodu8yvWjmVYRm5TVstQTeMdeYI76073ie63wYuDCPTwhpcaoGpNwfFr
         RU8NjohrS1Fc7BvqNianNACPtMXGQOUcTWjpUBq6jxdOOm/7ezQ7TQeALRHpHtSe+00t
         r3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709308529; x=1709913329;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cAWTzafg6SPo4FfnmrTdAIG/dU4gxVOaqWTDkLn0alM=;
        b=wF2k8Ys5qh5i8ceL6MXlTXeOH6UiADH2aaB9l4A/OLAI0OTq2mxKABWSNLdLhjdwse
         rBhGy5mccTpUkOlMxrt/tcymVrwteAJSFfIc/21K26XXDEYQBACudi+o9R1t3D/I/J+e
         x9aofx5y6Am5rHIPV6UCN6H7o9CLx53m+5swvvZSsjJZ9JIR6iN198l6SmNRNg6imXas
         2VweH5t/B7rk7sMpOO8U3wO2WAIqHfETnHzyaVqPVklmzwon30W5RqlvbVR7j1UyOq8g
         hOa5OgUlXg6KTm57Y/QkT19KA3gMl9LXgcsBc4Gh3FdWORzjcRQMkD/6SAyEgVduYY9A
         cX1w==
X-Forwarded-Encrypted: i=1; AJvYcCWYGnKuobiACX6Yc4A85yRI7DJDX0Dv/4mDKeM65GPfpugOerXvPwTzS3BRz5Z1T6UzuWZdNx/VCprPwM9ds9wso4/oraq4SjE=
X-Gm-Message-State: AOJu0Yz8Xmt5bdlEZbOLdU/bqAAknpNQ75D1sx6kN9+b6A48ce5Y8xYe
	nt94BZ312HLuh1fiyZHAM+nFHjHEygZOaAZD7dzjhSBxak5ohR7FciDNRTr7fag=
X-Google-Smtp-Source: AGHT+IH2AOVQ8MRVaLOMNYPUdikaYE3C9/yoGEwzLVtlfctn/SxJ+c3fl6voRhYHWRtZLwheJYI/Ag==
X-Received: by 2002:a6b:670a:0:b0:7c7:7f73:d1a with SMTP id b10-20020a6b670a000000b007c77f730d1amr1900238ioc.1.1709308528831;
        Fri, 01 Mar 2024 07:55:28 -0800 (PST)
Received: from [127.0.0.1] ([99.196.129.26])
        by smtp.gmail.com with ESMTPSA id b4-20020a02c984000000b004745e754b73sm894609jap.176.2024.03.01.07.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 07:55:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: kernel@collabora.com, kernel-janitors@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240301144349.2807544-1-usama.anjum@collabora.com>
References: <20240301144349.2807544-1-usama.anjum@collabora.com>
Subject: Re: [PATCH io_uring/net: correct the type of variable
Message-Id: <170930852175.1084422.15074919053163753559.b4-ty@kernel.dk>
Date: Fri, 01 Mar 2024 08:55:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 01 Mar 2024 19:43:48 +0500, Muhammad Usama Anjum wrote:
> The namelen is of type int. It shouldn't be made size_t which is
> unsigned. The signed number is needed for error checking before use.
> 
> 

Applied, thanks!

[1/1] [PATCH io_uring/net: correct the type of variable
      commit: e86b4a164fc86d224bd177e02a9c070b9f1c3db4

Best regards,
-- 
Jens Axboe




