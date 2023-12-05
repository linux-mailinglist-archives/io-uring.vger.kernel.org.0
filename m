Return-Path: <io-uring+bounces-240-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D4B38059E4
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 17:22:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04C36B2118F
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 16:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C215563DFF;
	Tue,  5 Dec 2023 16:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RtzCZh5Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F34C9E
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 08:22:29 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1d0481b68ebso9785465ad.0
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 08:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701793349; x=1702398149; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H/SsCJR078yW5wNi1Nlk4sIcdfiKFED+98FGl0+7gCw=;
        b=RtzCZh5QGqltLX9pxSxbJxIrBskC39hpgRJORToqLSy9QfHnqgwB3jVNzolGZvhZBJ
         M2GRogzx2pPlYMxqtqr3a1MD+HoS7PFDY87ba7DmNtGmChbUausK4LZ+1A/k8FTgNkNW
         NFT0JAmxCZo3mIXCZbYynR1EvxkViB+wVUFk+XPBxUWZPRcu2gnRfamQYAyQp/qufhNE
         BXQjr4fRYfQoHeDGDgBEZ20N+OfydnzbBCW7J6ZUxOJ2KoxC91qvLCCg2RfzGZjqXr6F
         pdDmCE8WNfgE4JZxTowjxbyntw/QWkY0Uqiav12PlS140RkLnHvRFA09nThFN8HoC2dQ
         rPRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701793349; x=1702398149;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H/SsCJR078yW5wNi1Nlk4sIcdfiKFED+98FGl0+7gCw=;
        b=Rkneji7qEj+PjqZZa+dAVyM/amvdCwoA+Q2+nYP3OEavh6dPqYL4QwTMXQ0LCQT8cr
         S4FJ9QKKz5vtu6PHeUzpWhp85SNLT3IScUWl1H0ed4/TXxgaanqVHTZsRxXaCpERwHeZ
         33BP6YW2lKegYCQyf53bIX3HVjaqPqHK4KaEtYQxNFl8XcMEKrIehLmnAX6o6fFalOC1
         6ixw6YoF7UlXsJu2paitx4YjOjblqFNoF7F5aQkjDpnk8ZBGsUAr5iX1XACr+cjIJtKQ
         vz9s/krIsi3q5VyqzINcGjJU5R+npQDNbMjYR/803M3WhHnurtfOzZgGTOl74f8W8NyI
         pQXw==
X-Gm-Message-State: AOJu0YzGoioNpaHkV3ClFCU+aex7VjxQg/MqIz6ztO11CjTngM9vjRlx
	+mYx7p0DQwGYcx6aE6s3N2jVLZ5hu3uICUkaNTC5ew==
X-Google-Smtp-Source: AGHT+IFdy6yzBVyrJEW9ic33TbwdUkvv8JtY+94cfRRXJhJ/BYp4h62si4xnqc1hwmwrvOzgY3Ew0Q==
X-Received: by 2002:a17:902:e881:b0:1d0:c738:73c8 with SMTP id w1-20020a170902e88100b001d0c73873c8mr1919652plg.0.1701793348625;
        Tue, 05 Dec 2023 08:22:28 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id iy3-20020a170903130300b001cfed5524easm6784714plb.288.2023.12.05.08.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 08:22:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1701789563.git.asml.silence@gmail.com>
References: <cover.1701789563.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/5] send-zc test/bench improvements
Message-Id: <170179334780.1467554.13296665238355789535.b4-ty@kernel.dk>
Date: Tue, 05 Dec 2023 09:22:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Tue, 05 Dec 2023 15:22:19 +0000, Pavel Begunkov wrote:
> Patch 1 tries to resolve some misunderstandings from applications
> using the send zc test as an example.
> 
> Patches 2-5 are mostly quality of life improvements noticed while
> doing some tests.
> 
> Pavel Begunkov (5):
>   tests: comment on io_uring zc and SO_ZEROCOPY
>   examples/sendzc: remove get time overhead
>   examples/sendzc: use stdout for stats
>   examples/sendzc: try to print stats on SIGINT
>   examples/sendzc: improve help message
> 
> [...]

Applied, thanks!

[1/5] tests: comment on io_uring zc and SO_ZEROCOPY
      commit: 88d99205fb4a6eb90dac88b0b44e04c88b74ef39
[2/5] examples/sendzc: remove get time overhead
      commit: ec12f8c51af0afc3ebfa2db461c7737e5be012c4
[3/5] examples/sendzc: use stdout for stats
      commit: 02866096e714c9e28616b88b5f79c509520999b2
[4/5] examples/sendzc: try to print stats on SIGINT
      commit: 6bc6fe9266abe7054908cf10d6b3d0077f7d7465
[5/5] examples/sendzc: improve help message
      commit: caa03326c5b6f6d5e013dd1c1a9adc64499e8cec

Best regards,
-- 
Jens Axboe




