Return-Path: <io-uring+bounces-121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FD9F7F314E
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 15:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F931B20FBF
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 14:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB283495DC;
	Tue, 21 Nov 2023 14:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MhZmgjvR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B4790
	for <io-uring@vger.kernel.org>; Tue, 21 Nov 2023 06:42:36 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-35904093540so7088565ab.1
        for <io-uring@vger.kernel.org>; Tue, 21 Nov 2023 06:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700577755; x=1701182555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X6Y0NLYl6pXHLUmq7iy8AFWeOvkVdKAEVFAjAp7dFvQ=;
        b=MhZmgjvRxK2khctP/i+JzH5E4ThQLwQNrH3DknTXDsw32Yu3wkAu+pNS1vxYD/5DfZ
         K6TqHaKAFsq71CmmpMVvu9Uo59Wr3YaO43q7glB88MWn1LUCu9a7ZlK7A8fCl1JL3KnG
         8Pjh7UkbbAnrwFpfnIgdIij6h57oBlOfHYuuhWx0U4v+olKkkZgxBzt1Cc3Hw1HEW0pt
         sO33ZNb4plBY8KwttY/wOdKQEKXRo7irMYqek5tAfrBaQGaDu30a6SCX8qZzHNBkgC7f
         YVA5fJoPoAS/9EnZ1PXAE6iJ+8nNlnoh4WOOsyTIWiHo9YjUA0bzrBer8Ysj97g4sfRL
         8MZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700577755; x=1701182555;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X6Y0NLYl6pXHLUmq7iy8AFWeOvkVdKAEVFAjAp7dFvQ=;
        b=R8XHQ77ViLlvC4/U3jBbgzQRZHJzjFEcYxV/PBYzF/GkMWtf0x5SG0P1HKp1zXSi70
         fpep6b+E3C+V8dvKZFZshiHbOjES0FMcitXke8w7FaQy7Hu7E+IchotamnHaPs2SJltB
         W11N+1+oSuhNBmZz5o82TJWBb2ps4oVHx7Lx4lsFoHEM2OEsKv65FRfzwTvbVIevo1fn
         fLF6D8cb8ykrzE2wVmiwixP3cMfqR8h3LY754/AmuHB0YwgTZ+aroo3Ajc99n9Gs2jkc
         6uTynh63rFXouvKM1cOkYEqa0wwhTCgeFu1rtVnkyGQEBfxXXfEwfDQg9M9qqZjhwwNN
         /UFQ==
X-Gm-Message-State: AOJu0YzuJt6OsKLEjpVn+kwHH1GxDFB/XxCFjbYKrbJW5A3JmbmFOu6A
	1l8qJOGHHZYcFMFdkV+I3pnUzw==
X-Google-Smtp-Source: AGHT+IHibxlJU0xr1NF6DlHxQoyxZzL2rXJQtYM33/a1BLlvN58w3+tOzyouNynOxVYzKMxGnFjM9g==
X-Received: by 2002:a6b:6c10:0:b0:792:6068:dcc8 with SMTP id a16-20020a6b6c10000000b007926068dcc8mr10307276ioh.2.1700577755445;
        Tue, 21 Nov 2023 06:42:35 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j14-20020a02cb0e000000b004665ad49d39sm1187305jap.74.2023.11.21.06.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 06:42:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, asml.silence@gmail.com, 
 Keith Busch <kbusch@meta.com>
Cc: Keith Busch <kbusch@kernel.org>
In-Reply-To: <20231120221831.2646460-1-kbusch@meta.com>
References: <20231120221831.2646460-1-kbusch@meta.com>
Subject: Re: [PATCH] io_uring: fix off-by one bvec index
Message-Id: <170057775460.269185.18412729294401034144.b4-ty@kernel.dk>
Date: Tue, 21 Nov 2023 07:42:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-26615


On Mon, 20 Nov 2023 14:18:31 -0800, Keith Busch wrote:
> If the offset equals the bv_len of the first registered bvec, then the
> request does not include any of that first bvec. Skip it so that drivers
> don't have to deal with a zero length bvec, which was observed to break
> NVMe's PRP list creation.
> 
> 

Applied, thanks!

[1/1] io_uring: fix off-by one bvec index
      commit: d6fef34ee4d102be448146f24caf96d7b4a05401

Best regards,
-- 
Jens Axboe




