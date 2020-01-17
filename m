Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B08B1412AE
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 22:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgAQVQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 16:16:41 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:38668 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgAQVQk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 16:16:40 -0500
Received: by mail-pj1-f53.google.com with SMTP id l35so3882375pje.3
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2020 13:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4+z/de1l+k9mLOLCf59mF0vCL8+HYdQeSPSYZkj7J1U=;
        b=mnpD91qSdBfL0TCATzTR/YTVE0BwCKm6ryki9nHrCutZtbLKcxxPeWaEhTmKTSQ7cN
         572Dpem/6cqDaH1j2C1CKfklJ35f2+95fIvI8Ru6/qE7QYdyabSAtxkXDUimwwEhQuW8
         Iy0HmkgNwKk//dP9rN4JwlkQHIiiiyCpgLTJQb7uUEqnmdaiHWLbPgrsn1b7TOCI45v/
         mq0HhQE8g/8+6bOKWOUyEQua+MleriK8czV1nqvoME5IaZIJMZ9yZctvZZeqgjYI5MwQ
         FDfa7tvm28oAdlqsIEszPqEJf91q7P7jvdEmDp8i9KapO/K2zjph1EFiySyhVAgA7OtY
         Elhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4+z/de1l+k9mLOLCf59mF0vCL8+HYdQeSPSYZkj7J1U=;
        b=nTayPwsgKe4ISwqLi1ExS9HW/arU3irnKa2XDIZ1c1xy7XFEszOimrpBVXR45IC1S9
         TTekuStuSlbVUytnypbz2MzQ78isolCZ6yPh5krZ3pquC2DJC9hh+I2Bk3WFk4hlYt5z
         6VGANa5BzoBNTjjAl5zHIHpI8NqvlUxRkcGjT50kf0qYdPuajU2q5YAxoKggwf70RgAG
         FN45Xyq4p6TF8sxYEsrSMtBOK1G6FBT+lfBJt5k9FflXKa69oGH0VrwMVTo/KeT/Kxk1
         W+IAjlClWUT6hMSvbTJfmanj8ab5nh2gLB0yyXDoeFL4FKjVNkK30UiEXnoJNiVl4tBZ
         z98g==
X-Gm-Message-State: APjAAAWx5XL8vO3cWvhZHLixk0tPeFjJzyvvs+BQ2XWhcqPz5FNTEWAB
        fvbp5NP5JwPZlMwAjWjM7TedkGjLSVY=
X-Google-Smtp-Source: APXvYqyYc5RBl3cu8hZbRP/JP2JWj9U2O1xJF5YXL4Pg1FLySou54fr8pAHdXnfhxNseseDxCghWSw==
X-Received: by 2002:a17:90a:31cf:: with SMTP id j15mr8225631pjf.120.1579295799659;
        Fri, 17 Jan 2020 13:16:39 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id m14sm3689554pjf.3.2020.01.17.13.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 13:16:39 -0800 (PST)
Subject: Re: [RFC] io-uring madvise
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <69c3d3e4-8ed2-3925-b109-04318a8f97a7@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6cf9d621-5c94-3112-4bf1-9f570040e042@kernel.dk>
Date:   Fri, 17 Jan 2020 14:16:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <69c3d3e4-8ed2-3925-b109-04318a8f97a7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/20 2:14 PM, Pavel Begunkov wrote:
> FYI, liburing tests showed the results below for yesterday's for-next kernel,
> though it's not reproducible.
> 
> Running test ./madvise
> Suspicious timings
> Test ./madvise failed with ret 1

Yeah, I need to improve that test, it's not very reliable/

-- 
Jens Axboe

