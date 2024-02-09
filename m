Return-Path: <io-uring+bounces-591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 719F484FC79
	for <lists+io-uring@lfdr.de>; Fri,  9 Feb 2024 19:59:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3C2B1C24ADE
	for <lists+io-uring@lfdr.de>; Fri,  9 Feb 2024 18:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB6150241;
	Fri,  9 Feb 2024 18:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="v9qjnWvG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431B353398
	for <io-uring@vger.kernel.org>; Fri,  9 Feb 2024 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707505157; cv=none; b=MDodiGKKsy2bpbgJjofOHRNP00vMS00crgPnKLdRLcjDEXiN2Ik39nSzYOyxoptpnXp0xBPVcORLpLRUyGzY3QyJ2Q5zfJ4ARqF08UfB2MjLcMK2RmvDMaQ9GVcY8IqRLII6scX7Gzxe1ri9KhAXLgqbjsopPcXGfrg563P9ZHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707505157; c=relaxed/simple;
	bh=FuKeRVEHvqr0Ai9dEH/ibDBBYFeDaC7JibLB1iKI/OA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pv9LJqO+5vim7Cl3qNpu6pqdxg0fEM/gQSnyY6NMdsZOnf1mJapfIDT20JoGelz5FUvth3Mfsk/7tUAwooYH4yM/mBa2oDW47moXFRxFNpcbPXtoW376PV0mQelT59cZIhAnQzpucZ6XPMXomySB/EaAPOJC3zpmaubVu8MhRBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=v9qjnWvG; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso22925739f.1
        for <io-uring@vger.kernel.org>; Fri, 09 Feb 2024 10:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707505154; x=1708109954; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZCFSfPTt9vhKr7HB9Bbes7G77291Y2duWn7XOAn95uc=;
        b=v9qjnWvGPQvAknFAQgpUkojaFYIuUSEFLV49N6gk76lgBODoT2QvqiQwztAym6bj8r
         +yNYFG6pNA3p29IJdpwMZgQQIBF1tPC+ApT6g7DtOsG2lbiHuuNepI9W+gymXm9vG6Ap
         PIH3lPBS7rVHogbLBlR/OAKM4q3eCt1NF08LGhL2DzGDgHxfCNLmuTB/RDMH4KMMtBOs
         GFIOwjAp97uxdhS5SxFVcpgz9Jh4yrgA42yvxtxqOpbMZOsYeJhqT5DLnqPDnzHrTUyF
         Kqkz2XoqxfATZn5OKDMNLy2RfKG6kYsjexUfRuj8g/1i+ICFu+JQ5+y01Lww35mO7+ah
         wPqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707505154; x=1708109954;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCFSfPTt9vhKr7HB9Bbes7G77291Y2duWn7XOAn95uc=;
        b=Ox82J68wu9KbtIHIEFrao//YEGNm0y+dJtpjcmXiaUX1R7AieYMRpMqZxjpCtsJSJw
         A5ZCVIuSW0CZ4380r/NsGJVIOL6t6u3rFYkd7YM3wIKpILlESz+4VTvtMjJjU3jF/hDx
         LZ08xnHGUwNvY4dGfpzIlODRwMvWPOKiTJJsdAXytncpAAGOSQlPRRebJ8/Gtp418XPg
         eK1/IfqgFux6FDP5GUhzOJKaWXfnvdurQfV5bmSwSW0bokEwGvLVHQYNuR63Lax1gDXz
         tuPkeX2sxrhCMVMOK6fPnJ/k9fUo0yO6Bb3KXOUmyoVKUELyq9nBwdxFNgx10C+QW/qO
         QQLw==
X-Gm-Message-State: AOJu0Yyw8vS7362kiqyRMAlG5S6Rtx1bwmkQtl5qCzcl/ih7ZKEE6yx7
	QHSCYCccpFMGVG69E5lmFe3rg3VaYod+htibH/apPtFWElTrp4Aju7E9pjANSKWwKP6jDWgYezu
	Ufig=
X-Google-Smtp-Source: AGHT+IE+ark8q4Z1GehIUR8/gcq3dRKNUEMfvhBqn2eiTkZRByPPkl8ZeYlzrzmOu+hgt39LmrGIgA==
X-Received: by 2002:a6b:3f08:0:b0:7c4:655:6e05 with SMTP id m8-20020a6b3f08000000b007c406556e05mr221669ioa.2.1707505154202;
        Fri, 09 Feb 2024 10:59:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXAfPTmBIDas0YsE0TgGAHGG8+3yoinx8HkwMW6/P5gr9MtNPew9o0ZBLbuo+kXZFHVSsNost6CbVMJ9IL/640gdPJN8ShcRIqSxjFyCkVCeGFZ4gOQ7tkbo2ljYGcF
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z26-20020a056602081a00b007c0126a5a38sm565975iow.46.2024.02.09.10.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 10:59:13 -0800 (PST)
Message-ID: <0da3e548-1b20-4ec6-8de3-e2c4d1c86d47@kernel.dk>
Date: Fri, 9 Feb 2024 11:59:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v16 0/7] io_uring: add napi busy polling support
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, olivier@trillion01.com
References: <20240206163422.646218-1-axboe@kernel.dk>
 <20240209105105.114364e7@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240209105105.114364e7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/9/24 11:51 AM, Jakub Kicinski wrote:
> On Tue,  6 Feb 2024 09:30:02 -0700 Jens Axboe wrote:
>> I finally got around to testing this patchset in its current form, and
>> results look fine to me. It Works. Using the basic ping/pong test that's
>> part of the liburing addition, without enabling NAPI I get:
> 
> Pushed the first two to
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git for-io_uring-add-napi-busy-polling-support

Thanks Jakub, I'll pull that branch in.

-- 
Jens Axboe


