Return-Path: <io-uring+bounces-3825-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 065CA9A4600
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69431B22BD7
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12033204013;
	Fri, 18 Oct 2024 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hJN0mB1W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3466D2022D7
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 18:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276675; cv=none; b=EuP+qII/n+EnLQGRPVngQwqoH1IvPgUfWPlqvMILFGh5DZtaUMjJ7eJlLqh5/vvVa6FTCYX7Et1vAQCKPnA3syzuUM9DyQ/BkR1tuh63C8vR29wJug5zVR2dr4Jv0oBZfLYQ03drsCm6ZzjJIKA+ZobP2/QLr5fXvnCA3i4iccI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276675; c=relaxed/simple;
	bh=LU6FZaADkat6/7g9slYHKy5MjQoU6fT70djXCBt9RKQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JYYfm20PivNTg3R1yBIMVOwRTbDlEUAVD54DRrAflyndX4DWM5vNJAPRW+WCFXtIFwxHNMi3jc9kowRYJR3YATH4moozfUjdmvL5nC2FEZwSwJcvtFHp5cWYJkPAeNYvdJkm9U5YnLvGKWf8JNXzc+cfU3w/BGjOM1S+BahnTEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hJN0mB1W; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a39cabb9b8so8741555ab.1
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 11:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729276672; x=1729881472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G0cNXlZSkvxC1FaY88xwRmlcv3dqAQiRwyZroqU4uwE=;
        b=hJN0mB1WfWr5HjEjOc/qZwJQMvIAL3nSaqKOzqwoYvJ7KegA2io19EMk33fWybTMPt
         esxSDfRhTsnQq8DuUL9srQrCBQc8cJp5xYSPnWRXmyisZozjREgfk0BOCm4Ccojp56Ei
         DApyJqdmUsuB8AAmC6dGvjQMkwUPHxsx441m1zLsCTeQwoEQ64p79RUEor4pxjTbgvJm
         je/LA1FsJMgSl7v89hW0ZSgV5uSlGEXwK30eKZJ1pnNyF2C0KpGYq/aOv6+218GxTIpW
         1ybBhnsOb7qDOtDoikULvtseYmI51NmyW2fnS09GFFf3UMoAYjrTmMhdvQWeqHeC4WFz
         aQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276672; x=1729881472;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G0cNXlZSkvxC1FaY88xwRmlcv3dqAQiRwyZroqU4uwE=;
        b=ZQUcwhh+C1YfGMtMkZRBFmdaZkLMi9DOaQ1+ahx+oMQURWmZl2XBupEW94Gc2Rj8Mi
         yfyBnAbxQefP4Ih21DI/mFTuCDs3iilvitK/uinTAoiyyNoR+SoPrQXBqRY9RLdk4uvK
         0iKLSHR8Xb/gnxCBOoAXDHYgQNRP1IDjpYVwUYVpiCxrGW6E3iYpagMYA7PuasBicCZX
         xUnuQ+gmfbKUDZZI6zPQpXVL1kvHtgzAn8SyvO6PMHJ/HGLISuaT4lk1raIfb6yCsUSc
         BJ060sFBFurx0UnU3/nU6R2AAKFM3npN0KED8wejZu+t6PMVAh8laBnEHMMRKCnz9U2R
         oi3A==
X-Gm-Message-State: AOJu0YxPYyADpiuDfzQNMqWEQzRwgVDoY9O+srRrjkfik732bczPFBxy
	m+khnF4b3LUv4vj8eeUdS6M8UZ052XCDNlJ754yb2ySledgdhbiC3Q3GUpBj/pQ=
X-Google-Smtp-Source: AGHT+IFIsz3ohD1wL7HrjME9exJ0MqpMl+3f6j7NtMZflJNkqiG2GDh+1tdD2FyCCyE3WCUegLyiYg==
X-Received: by 2002:a05:6e02:1906:b0:3a3:c4c9:8 with SMTP id e9e14a558f8ab-3a3f406fea9mr35236345ab.13.1729276672236;
        Fri, 18 Oct 2024 11:37:52 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3f3fd7ea6sm5366675ab.9.2024.10.18.11.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 11:37:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b83c1ca9ee5aed2df0f3bb743bf5ed699cce4c86.1729267437.git.asml.silence@gmail.com>
References: <b83c1ca9ee5aed2df0f3bb743bf5ed699cce4c86.1729267437.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring: clean up cqe trace points
Message-Id: <172927667053.464574.1816667534781050452.b4-ty@kernel.dk>
Date: Fri, 18 Oct 2024 12:37:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Fri, 18 Oct 2024 17:14:00 +0100, Pavel Begunkov wrote:
> We have too many helpers posting CQEs, instead of tracing completion
> events before filling in a CQE and thus having to pass all the data,
> set the CQE first, pass it to the tracing helper and let it extract
> everything it needs.
> 
> 

Applied, thanks!

[1/1] io_uring: clean up cqe trace points
      commit: 525b26d3647037195dae188b6d706eed1fa9e5fb

Best regards,
-- 
Jens Axboe




