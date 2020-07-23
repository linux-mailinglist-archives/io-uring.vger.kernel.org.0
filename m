Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B3722B563
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 20:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgGWSHg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 14:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgGWSHg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 14:07:36 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11313C0619DC
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 11:07:36 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l63so3502735pge.12
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 11:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pq9yKxRjeLmK3rItY3I4saTqSgk0urB1ggiywvr3oLA=;
        b=AkzULAI4cmTWIS1g3li3MZX6XoNA0FU1qgVkrK2D0xNdzA0AH1ihh8p9sTrBC0g5+S
         hlts17pNSXDpGXQVd661wBwEpP7A0VuJw+qIoia6bJBTnWS/WrsAqa6qqiyjdYFtMuSm
         xmzjEbSOdWsPfkNvpbGtn2i/Z4N4F0/8CIdlmr+n4oTdarKCe1QLHIoYxIMy4ZLo3n0+
         ArIMp700L9I45XkNPt9dp4bnAQz7FQLUdK24WHJI3k3lx8P7OQyX/jPDooVaH12yC5W4
         d5zvrY7kClXjvH7vB4L1jDndrsiarZFrrLp1dnlnV8gYtJ3XMSm63oHmjyyjYzctFmR6
         2/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pq9yKxRjeLmK3rItY3I4saTqSgk0urB1ggiywvr3oLA=;
        b=RbWPehqn8/MUHs+PrN2wNYUYu5Ri6FJc7DezhyD6oCrNZAe7nUV9MAdGA9kbJEZgkK
         sTFd4Ysk1OdFsOW3ZhEkjh7h6Q1UnV+SprbqnexbrDQdN45xRgUuwIS4hQscRl3INlAD
         DqpJjhX1qSOFXNkXIhRhHszMk3xdbC6aTCFsQlMzsfHbHuvxHS3hOxIbuctzvGvJLeEN
         iFgM6SpjCQRLCx+B82TDRGw/ani9qLMsxEJMz76/3oaF1WeYjmF0r7PwwDJSbcDSxK5R
         HKsNg2oNz9S9w3sbeV9O3zx5PmC363tAEyqHE1KN6/6NhYEPGYxK8ncMD4zg7T7M27pq
         8h9g==
X-Gm-Message-State: AOAM5333Pg88x4zK4Ym+QyFue+j9jC1RzOYTU+cOw7vhZhFm74DoRiTl
        ZXTX9xvrwD0KiCWKNv9mfbB6L83t3+mYUg==
X-Google-Smtp-Source: ABdhPJyyr+Pys870sZB/U0vPole9mfdunPuyo1xyDd/PyngmmVgVWINJthLSWOzVn5IvksOvww2auQ==
X-Received: by 2002:a62:768d:: with SMTP id r135mr5542379pfc.198.1595527654850;
        Thu, 23 Jul 2020 11:07:34 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h9sm3395134pfk.155.2020.07.23.11.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 11:07:34 -0700 (PDT)
Subject: Re: [PATCH 5.8] io_uring: missed req_init_async() for IOSQE_ASYNC
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <fded2ef29b36bcdba4e9faf2de6a1ef2097c6bbb.1595441706.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <90b53d5d-c1f0-fc9b-36f7-e92a442f6781@kernel.dk>
Date:   Thu, 23 Jul 2020 12:07:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fded2ef29b36bcdba4e9faf2de6a1ef2097c6bbb.1595441706.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/20 11:17 AM, Pavel Begunkov wrote:
> IOSQE_ASYNC branch of io_queue_sqe() is another place where an
> unitialised req->work can be accessed (i.e. prior io_req_init_async()).
> Nothing really bad though, it just looses IO_WQ_WORK_CONCURRENT flag.

Applied, thanks.

-- 
Jens Axboe

