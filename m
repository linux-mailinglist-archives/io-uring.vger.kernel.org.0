Return-Path: <io-uring+bounces-2582-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C76D93C62C
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 17:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E977B1F224BF
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 15:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00FD719D887;
	Thu, 25 Jul 2024 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oyCN+ZRA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E52819D07C
	for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721920193; cv=none; b=ljdrSJ9FirfZLwITNTbNNIAJrPtq+YPRehaCb7Klh/R/ZIgIusVNwQKAkLls81W5gM1C12ozYI0gYu6Dd9SOqCV7KMud8a+NwGqEmf2o7kAN7Ynz18IBmZuK5UHbAPznmQJITmxcOASePyD/Wc7W1Tuovtg4oK1nfcwrl73RVvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721920193; c=relaxed/simple;
	bh=MS6Xoxn+YOJVUD4gGLD3qQML8Z0HGqpjFbs8eOGlack=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ftt3hqmjJOBLv5e8Lsd5diszUB2FF3/iSW3jgmqB0TTXGYr4iwCFToSVXQNtJ2eSOiEl+RYq/p8XowZiy1OJTLm5RRN1izNR9VHSAnzbZXIupRWN3+rlrrxiKvyXj5goBv7nZcxCcSPUXyfGat0sgh5BSCYBOdKu4R0vvwPtlR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oyCN+ZRA; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-70d1876e748so108663b3a.1
        for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 08:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721920189; x=1722524989; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6i1BHgQZwRlv63L1Gqaq5LbuMpS4Suiadgshakn04BQ=;
        b=oyCN+ZRA+WoxVTdmFALTdw3R7wnDQbkZi+cmTDk5ntb4reAPdFNQiPARbpGLoodShc
         7DihqipdQ+a8Ez1XbX3Q7eRTxDt3yQFd0khAftaKSn9pOpYpN7jsM5qpvplLGKW/In7O
         nCFFVC5M3T+BMzYzSWC2U4IsT2JWo5HKiwNH2msaqSj70O4LNjwTJboMJllqWUNcSq4D
         ZIqUyNNHXH+VdbW50oPCSBmCLKpEycQiv5ZvNPcBUTtCX5pv6u6+KAvkI6dy2c3PWeWB
         299vQ4BXDAerxsxhG4cspgJBVbk9E3wGEPij9ciwA0Aay4qN5LTUUOPl1FPfze62HmAf
         rLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721920189; x=1722524989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6i1BHgQZwRlv63L1Gqaq5LbuMpS4Suiadgshakn04BQ=;
        b=CtPx5dwP2xWbvj+ITTvu49Akg60EaHljXwXdpdTcDOEDnxTfqw8Kq/m4jDlBzk5GU2
         Jh3hplEWpaw3OakjwO9Qr3DjZMzjTrNeWMYapK/nl+Qah2269QBrCjWJ7GLXINMWEKVI
         6pizYH930j6CLRFni1bVXO67XMi4J+F88B4LqgxPxL/+hsgDgdLql0E38b+JJ7eorhQB
         bZyolQrorcXljMUpZiPdsOsRczIZOGJawCnPxNBRl7qq118bnZYPhDoVdvO/B5T+Exx+
         Y8LBkkHhAIJu1kCDNF4XiHxLMEMdTmybQJKnmVG//zAHukiAjEGtypRjBpFf0PmbltTf
         eVFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJXJ0DjtTmMOoyIJKvpysangEtIGhTZ+CiBkP4G8awIjMIDS99RwEWyMvJAHUf+6z7GrZgrCMXDA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yymdy8fFcgahV4KjmZNDroc54oaZ7vvzkR+EDSSlsnTDe+3h+5g
	Cw6iA726qxmDvuxrfLVFHeacaQ6TzZ/nc9W1yD9lkU1ZCjvsOSw0FW37XxFSZ2E=
X-Google-Smtp-Source: AGHT+IHBPOYujv6C2Y/Huz1P8gfquNShnmt5LVcXeuI9I+/n4qV02EysyYv0jENLgXtTijrIgBek+Q==
X-Received: by 2002:a05:6a00:3e26:b0:70d:2289:4c55 with SMTP id d2e1a72fcca58-70eacb4ece5mr1816471b3a.5.1721920189287;
        Thu, 25 Jul 2024 08:09:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead87a372sm1231642b3a.166.2024.07.25.08.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 08:09:48 -0700 (PDT)
Message-ID: <d39434bc-430f-4c84-b1ca-1025f55bedb8@kernel.dk>
Date: Thu, 25 Jul 2024 09:09:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_cqe_overflow
 (3)
To: syzbot <syzbot+e6616d0dc8ded5dc56d6@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000852fce061acaa456@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000852fce061acaa456@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.dk/linux io_uring-6.11

-- 
Jens Axboe



