Return-Path: <io-uring+bounces-84-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B06957EB2C2
	for <lists+io-uring@lfdr.de>; Tue, 14 Nov 2023 15:50:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5278D1F24F33
	for <lists+io-uring@lfdr.de>; Tue, 14 Nov 2023 14:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6963FB21;
	Tue, 14 Nov 2023 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BejncdfI"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368133FE52
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 14:49:56 +0000 (UTC)
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F84F10D
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 06:49:55 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-6708d2df1a3so7746036d6.1
        for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 06:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699973393; x=1700578193; darn=vger.kernel.org;
        h=mime-version:date:subject:to:reply-to:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uaaj5U5FDCPnJY0nv3sAqKFlwxAF3K4ULtNGwKCMahQ=;
        b=BejncdfI32sSBaL6vazjZfZ0mL31s9EoxXG2+aG4TZ1HK1S0hJt3qS3o+L8Olwj/UI
         bW+luC8DZpvwAr0sLmCcndKmo4y1iB+8cPD2mBWquywYlAeLV492hj3PI3omHbu1aJ5z
         tVI3sslhN+SA3r24zU/7hI6VLeZ6tRZkEojzWckAOFfXSRWL9In53HFeQAH9/1ZYzSZP
         dh6GK9/Aoy93EV7UDCPlm8WkWEcrQrPvNMhJ++uHYYTYI0gKJx5Wo6rJ3yyj6oi/YvHb
         OOGYVNnUEZaLBmWIfEQVwbUzSMNpcaockrdBduwboho7ibvy/SdFMdjWSUIRvDPirlkx
         hRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699973393; x=1700578193;
        h=mime-version:date:subject:to:reply-to:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uaaj5U5FDCPnJY0nv3sAqKFlwxAF3K4ULtNGwKCMahQ=;
        b=IZgD8nfzpQhdmQTKc5/uoWsdn1R1KTfmCm4UvmnDIms8Ur6oq27Mizi4sHsbfBp5Wu
         UPN8GSdRZGLgqBwRtDb7c9c+GswlxzhyJdjGRozo0XT98tQ0MmrBJ0WsCv6lpmMvneyr
         W6jb97mN6CllTJY7CmbMcDeoZnxLj6Ag8qv0OoCwIxYMdAFrxm1Pr7hLxevt0cXhacxu
         Et4xF5mULhpq61251HSsuFJANvK9ntN1ItGKyhbk01rth5GgVzE04lbZaVylYgybeiAR
         vO974qCtGoxem0/29kz8WyzNA2izhODwIEISSWHd5ecpnLCqhsQOfwAih+ooZjBHTlfu
         ktbw==
X-Gm-Message-State: AOJu0YyfsqAJd5f/O+8j1PXhrospA2s5wneo6P/PdoUoYyFUg/8CJNTO
	FXyFqgNbv7mdzHyv8aEDvtsuuvpxBAo=
X-Google-Smtp-Source: AGHT+IFf6tUOJnjvwS9jGPO9i/uQ15qe5d/iL3Q7MPeY35w8xwivgHmUrvE4fQjkdVunTr+TA6l81A==
X-Received: by 2002:a0c:efd0:0:b0:66d:1bbb:e9f8 with SMTP id a16-20020a0cefd0000000b0066d1bbbe9f8mr2383099qvt.6.1699973393357;
        Tue, 14 Nov 2023 06:49:53 -0800 (PST)
Received: from [198.135.52.44] ([198.135.52.44])
        by smtp.gmail.com with ESMTPSA id qj12-20020a05620a880c00b0076ef3e6e6a4sm2702831qkn.42.2023.11.14.06.49.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Nov 2023 06:49:52 -0800 (PST)
From: Peter Wilson <muthusachika@gmail.com>
X-Google-Original-From: Peter Wilson <info@alrigga.com>
Message-ID: <a1e5f3351add0689e0a5e5b1bd7fecd10d3b4f8bd75c41d16cba04c5f06112d3@mx.google.com>
Reply-To: mrmo754abc@gmail.com
To: io-uring@vger.kernel.org
Subject: :once again
Date: Tue, 14 Nov 2023 06:49:52 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Level: *

Hello io-uring,

Are you Thinking of starting a new project or expanding your business? We can fund it. Terms and Conditions Apply.

Regards,
Peter Wilson

