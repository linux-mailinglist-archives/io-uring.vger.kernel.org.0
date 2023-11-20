Return-Path: <io-uring+bounces-103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 162297F1861
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 17:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C659B28223F
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 16:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E289E1DFDE;
	Mon, 20 Nov 2023 16:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="z4tF8z2g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3949593
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 08:18:13 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-35b0857ce84so891005ab.0
        for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 08:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700497092; x=1701101892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/x/sugBcPo/wJPwRXmBQQN8tg2dGBuoc9WNETNOCDJo=;
        b=z4tF8z2g8QHCiMjTEoDfV11UUORHrc/GwOUPsHLsRQlTWEghJLfIUSaV7JdEicnsSN
         X7phuhbyp8iuWf1bcFGSc1OIX/HGlVgpDy3cGRg0dYyr2lPHnUf9gei2ve8bRFtrdJpQ
         t+FncKXtStiE2E2fjVQ8ZfV4afd22vNS51IvuaCidy9a0nVIsyVDVJkXb4FrdcN+4NAx
         jVpsCSziK8jKgYneBo0LxRpybBuTPcRG+ip213EUqKeratmTQC/z8tZ6c9SLrWpc9v8F
         +efKbcsFOylkxvVoUjXGV9z/JG0xBT5H/eWgLeZgQTp6Fx+f1znOaTeliLO7WCRKOOIM
         JlNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700497092; x=1701101892;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/x/sugBcPo/wJPwRXmBQQN8tg2dGBuoc9WNETNOCDJo=;
        b=hfM2ZUa/rSFwpziBhyFUdJ9St6msIEhuSuwzwmIKQ9Ms5FCBcR+nY8uOZXu8dPrPNK
         yr+4LqXXHPCBJavmgukbgiPwqWCi1/Z8xOks6mtF23G6gIXX6WTYyST5sdDBraV8rJDp
         cahYCnHt9IQlO2MK/qdHOjxKZTPjVnudUJLj7v/W78+gYnX5hUyRnzpqXIkdHSozOxac
         wZQ1FwPveqoXfgh+ld20Yq3vtvdytoHh2qTlbJ9FL3NGHA78ih/+09TODKpqaguk4xjd
         sCSRwIiB83Z53x762hm4jhSLddODUgNH2SjnPqn1V7jskaLIbQl1A2HmImElRWUNV1YW
         qWBA==
X-Gm-Message-State: AOJu0YztrpOp4gB5i4RjskY6UwxvkDHFNC+28xz+xv7r4WIin2QicAK8
	bsfMnEgRX+MucdYN0O/uId6aKot5JPSWNmVPTIgY/Q==
X-Google-Smtp-Source: AGHT+IHwfXliLfgkcDJcwMVjVN2qSgqAYam3YW3uzigd3xcp/putwJdxZNh1DNA0ZiMc/53RNKe66A==
X-Received: by 2002:a92:dd08:0:b0:359:d256:d970 with SMTP id n8-20020a92dd08000000b00359d256d970mr8026039ilm.3.1700497091839;
        Mon, 20 Nov 2023 08:18:11 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w13-20020a92ad0d000000b0035af9da22b1sm1521725ilh.43.2023.11.20.08.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 08:18:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org, Charles Mirabile <cmirabil@redhat.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20231120105545.1209530-1-cmirabil@redhat.com>
References: <20231120105545.1209530-1-cmirabil@redhat.com>
Subject: Re: [PATCH] io_uring/fs: consider link->flags when getting path
 for LINKAT
Message-Id: <170049709091.66373.13574561690128367398.b4-ty@kernel.dk>
Date: Mon, 20 Nov 2023 09:18:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-26615


On Mon, 20 Nov 2023 05:55:45 -0500, Charles Mirabile wrote:
> In order for `AT_EMPTY_PATH` to work as expected, the fact
> that the user wants that behavior needs to make it to `getname_flags`
> or it will return ENOENT.
> 
> 

Applied, thanks!

[1/1] io_uring/fs: consider link->flags when getting path for LINKAT
      (no commit info)

Best regards,
-- 
Jens Axboe




