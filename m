Return-Path: <io-uring+bounces-402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 288CF82D0E2
	for <lists+io-uring@lfdr.de>; Sun, 14 Jan 2024 15:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 853DB1F2161F
	for <lists+io-uring@lfdr.de>; Sun, 14 Jan 2024 14:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F5123C2;
	Sun, 14 Jan 2024 14:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JuH9bEwT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5611123BD
	for <io-uring@vger.kernel.org>; Sun, 14 Jan 2024 14:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5ce99e1d807so724762a12.1
        for <io-uring@vger.kernel.org>; Sun, 14 Jan 2024 06:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705242401; x=1705847201; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YgvPicHYAHMSP7JaCkgKQ3HWaYi8D+Ul7BveqF0AB+g=;
        b=JuH9bEwT9J7AYUOuIRFPg0fmN1VRX+Fbi9up8TuEaZdGW+4SAaHi7iOd+y+fP7pV77
         OXqXFegLgBvnvBG5yi7sPpyDbcmj1ThfTgoj0xSzCdkKq8BKYmt1ao8PD9EPZ+9YELQg
         nnSTJS7Few22gArcFfYjw7+XyXy9N9W2C7IZxN3/hDIcEtYf7i7QivGpB6PRqP0ZzvLx
         f2rb+847Ot4HdaHXuHyUvaRmhDOVKI9+XaeRqVv0bpkZRgzT/x4i29Z0ZMH/zic2M7/e
         unfZAzZCANTNbsKDUtzOp9LR375gG2EDzXrn7bO15gi8oUuLWYgrk3EaP1TnoFccxbkY
         YFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705242401; x=1705847201;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YgvPicHYAHMSP7JaCkgKQ3HWaYi8D+Ul7BveqF0AB+g=;
        b=GI23B6j7Q5APkZk9lRfrF9Ul3fUPO1ul1wgwYICTfXG2zuklnSDFTu8M/uJ1GiOMvK
         SiD60WHhZ2ZlzxFMtY93J7wPGxkSteI6K0ucRd5bM3q/qnVVShLtLUkYLiTr03JsDk8C
         6Cc6mVPZ132FIbD9R0nI64cUunriMjVZYm+Be3HU9xZ1+VKhyK3T+t9vC6lTShcHz537
         mxgppYOuQ9Y63Bv0Jh+OzB2Zfjqho6QapzvqqkuJ+KgJZQv8Mj2PPgz7F1TN/j5jpHWi
         yBNHVE0SIqZNsschJMb/P2AwtlOKspR6JUBy8ByxCTYLTDz/OIOjYY0e7QfdS5PVGJar
         Vlig==
X-Gm-Message-State: AOJu0YyD0VHNL1RTtWTAMwa1cUTN+JdvtZyHScbzbG+hE4cgldr64wn9
	3cQA3JKGa+T02xV/yb71Bks3xbOL80s7kg==
X-Google-Smtp-Source: AGHT+IG+tMcQu41vVh0L3LIA054UD7wMMv66Ufg/tQuvhLxO/ZBv8yoj12TsjTayOaLkYMOSHf22Tg==
X-Received: by 2002:a05:6a00:17a8:b0:6da:83a2:1f15 with SMTP id s40-20020a056a0017a800b006da83a21f15mr10128998pfg.0.1705242401255;
        Sun, 14 Jan 2024 06:26:41 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u20-20020a056a00099400b006da76842a66sm6055101pfg.85.2024.01.14.06.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jan 2024 06:26:39 -0800 (PST)
Message-ID: <3bf0382a-8e7f-4464-9b22-b9cf4fd37ba7@kernel.dk>
Date: Sun, 14 Jan 2024 07:26:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_rw_fail
Content-Language: en-US
To: syzbot <syzbot+8d9c06e026c513a69f2f@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000e06949060ee528f1@google.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000e06949060ee528f1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz fix: io_uring/rw: ensure io->bytes_done is always initialized

-- 
Jens Axboe



