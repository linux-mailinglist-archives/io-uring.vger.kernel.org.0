Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC844204C4
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 03:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhJDBjE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 21:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhJDBjE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 21:39:04 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2B7C0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 18:37:16 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id d11so16617873ilc.8
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 18:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G/rvRb7prENs2wJwe+Vl4dKQJqHWim5gowIJoUWQltk=;
        b=f6AfHbV5WXCM8uYMk+/kb8iZXwVd5rxMJ+MpxVN4LZAki4WmXYDNvrh67mdPHGko2h
         S71t0HUjIu+9/y+llYCNXeE6HGcZ3a/3MPXYzz9VnneifT+sy/kSenmzUMQ/DQTQq6L2
         lO6BTrMYPSm63jTAqj1IXauOxnXiFsXLChN1RSE1OIYPshDr+JNi33bd62Vy2Qr4rUG0
         9Q8Dy5UsLbRNZEJLcLPrItodERzF8gidkbjm6OKw8mMbCaHeqTsvNFsQQdglN3g9Laj3
         KC7b1zOrxaXsjQlsyAvrUwnkKhZT8J7ns0p+d+IY+ZRQvEaThjU+fWse1XJLtdPaxHHj
         odcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G/rvRb7prENs2wJwe+Vl4dKQJqHWim5gowIJoUWQltk=;
        b=PUFLlD4ALgNUOx6ghmTUFwr7pi1it7MvNsPcbQfRACNs1RYMksF6dWljv+wf1skjvi
         bgxvzTU8SRuVDu5cE1KHicOxLaEnWCC+uV+ySb1qGL1mEqt3XzKhrM6/VFQk2OU975WL
         KYEevii7vNeUHHfMRAwJG6vsKfOTcrEZTlJnhZ2WPn0VHypKgpd+lnwmV+xMGEohr6u2
         BubglLqzwGRS5Xxh1EPZ2AOCJaKO7eWNbD4H9OAoemk5IKNQ+mQbcOvGhV5tXx5xlnbV
         5rvDm3rY9ys1jy+VT9RLK/N7a2muqVkRVLb4oq0wSr+pPk5oNDUHEeQnZkTzCy75b5ay
         OM4A==
X-Gm-Message-State: AOAM532iblewNnJ1k44IGl44bCtdWJZMC974jgz/nKxNItNqaPkhT4fa
        x3b5AMxsiS0MGHCUUXLlpvStuMk6QNLHkA==
X-Google-Smtp-Source: ABdhPJxUdhsZXsBJcDfLLUbbNHICXrfaqCLQrDlZtzmwa1xi5CF3p61yut4Lqn3ptavLSZgSznsb6A==
X-Received: by 2002:a05:6e02:194c:: with SMTP id x12mr7578448ilu.128.1633311435113;
        Sun, 03 Oct 2021 18:37:15 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y30sm8711833iox.54.2021.10.03.18.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 18:37:14 -0700 (PDT)
Subject: Re: [PATCH liburing] src/syscall: Add `close` syscall wrapper
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>
References: <20211004013510.428077-1-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e2d18015-510b-1570-3b23-eae2c6e45d1d@kernel.dk>
Date:   Sun, 3 Oct 2021 19:37:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211004013510.428077-1-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/3/21 7:35 PM, Ammar Faizi wrote:
> In commit 0c210dbae26a80ee82dbc7430828ab6fd7012548 ("Wrap all syscalls
> in a kernel style return value"), we forgot to add a syscall wrapper
> for `close()`. Add it.

Applied, thanks.

-- 
Jens Axboe

