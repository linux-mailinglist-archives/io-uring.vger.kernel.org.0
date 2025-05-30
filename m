Return-Path: <io-uring+bounces-8150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78980AC902D
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E05C63AE52F
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0C0243172;
	Fri, 30 May 2025 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sqS79PLz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B27199BC
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 13:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748611642; cv=none; b=ezXFwRRTf7aLvdpvhIhlr6lZhqdkB1YyTgAqw2BQUmU2VJYUu64UN7+TgF/2psi3WtdJhlKgdZAo5SBlf0IOcaI/TK4dbWYGEt5RsO5F72OGwaLvrgJ4avYU9HJy1MlXLwjb/eguXQk1qCNLQ9GwD9ztck73hIgaLLUno0b9tjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748611642; c=relaxed/simple;
	bh=La62yADBaxSdX4RWIZLXroI36TuFjd7dpYQTHA3Ax7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lRoBFkWPkdfCgdsZfuJFYFHnZsqaHWKmus+UAtqRPp70QhSdZXLBsJ+gv4dqc3jMsopMqMWD7VaZBtIea8CQSQ4GtkvxLc5Ki+AIqoy13BjfL8+QiQnTnTcAL9a4N2zNfY66eKrHC6TMF/3D7JAQ22bXyqQe9bsRIul08CmZfFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sqS79PLz; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3dc9e7d10bdso5396735ab.2
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 06:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748611639; x=1749216439; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cctdpYC/TdYZ392ClsIzrmfWanWo3Afny4+MpjjWM7o=;
        b=sqS79PLz2PzkTefyqbVmRicIVAvebTHk6EYpZAeys8SIkPPG3+sTqacbRFLmOoz8yP
         GUu0HK6Rpool1Kfz4Rdu/G5i1Nl4y7VbqIwZXtymCgV63phaBnlCYYSIflgmAN9WgnDU
         JkNcreP2TLShmz5S95+H3Ss7aOI6iyYoBlytikMGurgsia47NYxdCPUwCQ1FZik5uUuj
         BAM9fCUh/3GAOAA8uZotzLaPUod9/3YKyrsSHaSdbq2/M7vN/ySXiuT+0aBXSmBJI2a2
         W2XTvIsBAuOhX0/G9qLbn19Tbl4gzlFm58IHshgUrecXg7fKj7FVT9Rxp9J4ArEk/58F
         eAuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748611639; x=1749216439;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cctdpYC/TdYZ392ClsIzrmfWanWo3Afny4+MpjjWM7o=;
        b=aITyXbkASc971eckrRtaNINYp4Wl/6j1u/YZFh+0Kdbg20FgpYUocf0sFGHvc/UedV
         qVoaZeJ+IcyZwZLsrsPTqoqxvCIHmqVqrc2cDecL1hvgP7+o9tqzFHnMJZKcedjKx98l
         yX4kMk3pjDl0TWX0tq/LNDArAGaSchDDaMIMA4V7FxbwqguWUDXhiylBPHjmXTlBtkIB
         JjK+4kVOrBiMntFbqLflezj8gYhssBtuah5QVkKO17Z1u4DaqeaCIBKKzWifc5rjN50D
         Tej7zQgbxnrCOp+/LkAPN7JpyZQqE9kdiuyzSnHXOnvkSl3eDZk5X1r0+qmfzV+4ptGr
         gdag==
X-Forwarded-Encrypted: i=1; AJvYcCVxsfgcs4/26uNY98Xkw18LsUmwZO1ao33+qJnxiGNdr/XMTUgqkHAXmCzsO19opQ7Nyot99jKzZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwI2bjYwqLla6oypXJWlGrmJ8IsINXJwLVi6Bsyxm9YV0VrHF28
	tHWZmh+DWoTFGApinoR9Aaws3y1XyPGY6uN/38tSjYUpceBR3OveBcU2OzK2ip9W/H39riR7kFx
	oIRU2
X-Gm-Gg: ASbGncvtmdacoVgA3OqH0UNYSg3zXCUhAVGQecKqe88wACT5np6Zlk9Q8l2V8HLe9et
	B8/SQaaTh4QjFupAeIoRctHBZfg3xlM+oGW0T8NHQqqgGKgsmqN9CuCKKb5x/BjS123XEH6J8t5
	02b2Xb1wlxmNd0S6aWnwhIlnwqp2MgoD80D6BYTFRL2wcAMUVHylbfM5OfHWeuoWNnI4cb1fW0h
	2gkcmhrQRRzr9Jvu46547rQubWiGvlM2KVwc0+HRITbXc+djujm6cp4ldohr2UshRqDQEpibPjb
	D7OQvpiQXdJ/8EM1HKTj64rHBWpYoxZ0gxBgCrGPvc7HIg5+hdDtTKUvZg==
X-Google-Smtp-Source: AGHT+IEfGJR4a07vWIJuYvLuEUxkSF95TH+Tq+B457gUUoxo5eWMccE+3KPj2UdD6tZ+cj/ZIzJAug==
X-Received: by 2002:a05:6e02:188c:b0:3dc:870a:e07e with SMTP id e9e14a558f8ab-3dd9c988805mr19063065ab.4.1748611638965;
        Fri, 30 May 2025 06:27:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd935a7aa4sm7904945ab.71.2025.05.30.06.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 06:27:18 -0700 (PDT)
Message-ID: <792793b0-fcee-4915-afdd-e13cb4d59a53@kernel.dk>
Date: Fri, 30 May 2025 07:27:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] io_uring/mock: support for async read/write
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6e796628f8f9e7ad492b0353f244ab810c9866d7.1748609413.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6e796628f8f9e7ad492b0353f244ab810c9866d7.1748609413.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 6:52 AM, Pavel Begunkov wrote:
> Let the user to specify a delay to read/write request. io_uring will
> start a timer, return -EIOCBQUEUED and complete the request
> asynchronously after the delay pass.

This is nifty. Just one question, do we want to have this delay_ns be
some kind of range? Eg complete within min_comp_ns and max_comp_ns or
something, to get some variation in there (if desired, you could set
them the same too, of course).

-- 
Jens Axboe

