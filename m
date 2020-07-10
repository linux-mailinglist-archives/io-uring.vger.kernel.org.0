Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAB221B73B
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 15:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGJNz1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 09:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgGJNz1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 09:55:27 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634C2C08C5CE
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 06:55:27 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k23so6051884iom.10
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 06:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LUR7XSl4anzG9Xow4IF929hO3tW1sLSj0vwm/LGn9gI=;
        b=aL5K9lSvDwzR7w9kcIEWCXKfwG4tc8Ig+sZWqeRf+DxyBU5Z46UQmxRAZr6xBm8oII
         6yd15P8qwTbMysb0qEq92xN6eda3Yuy48sUgfEtKhNTACeGONRmkC2K4nNjicISF0JAJ
         q36ZdZryHEiISE9vqGUMG2ExuuAAANUuSYXIGHxa6/ylKYKoPq1M9n+Nzr9k5TWdnI34
         ZKs9G4hhfLLAX+AgoH2pWaEhCOHiT6ZpWUUVP9s3kB7LGvcfaCF8qbaII7aGWAmHZ6I3
         FZjdtd6ws4XYMeVfZrhBKk2UTGSc/Ate5tlFpdDrE9cTk0jlnHG76/41gOsyEkOisror
         1oCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LUR7XSl4anzG9Xow4IF929hO3tW1sLSj0vwm/LGn9gI=;
        b=kF42AKkLZHpc5DyBDxOdimnrle5bfBOKXnrZJpo6G0bafYleed0yrQzBT8SQpjnI/e
         3kJ1vS1pZR3Ioc/xefL+0TPGesP+uM6n+RpTXPSnSz7xeaOQqgiWYEY0Oon4q7huXNz/
         COj6CII2f5WgkFxwAQ9nu2gfsU6uuAw5w+hZtaQ+MCOh0L68XemuCZv3bk53+CSDrtLj
         BUUBI0pU5ES6mLyn/7bE66XMWGVcsEJudpwdqP6BTn72j84Rmge+48iym3N7VcB1xxoT
         KG5BRtzwsS/WsiLXH+oIRHGz9fhY5xHsajUKALrCHUMUTzCc2jolDYMfZp16/XFWCiMX
         OCcw==
X-Gm-Message-State: AOAM533HEDW5jcK3eAvVoJvqAlstt7K7ONpxZ0xGMzeuXhRaKpnRUyMM
        Nl9fJISqPYYbrPop+qtcNuS3UYTJxFp8xA==
X-Google-Smtp-Source: ABdhPJz25JQq+ja9ySdHbT+X3SjbRaLqQ7dM3tGyk05eA4PKgDElMLMtNouK3yaMMyH9Cvocvk0WlQ==
X-Received: by 2002:a05:6602:29d2:: with SMTP id z18mr46754677ioq.185.1594389326291;
        Fri, 10 Jul 2020 06:55:26 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 69sm3595594ile.60.2020.07.10.06.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 06:55:24 -0700 (PDT)
Subject: Re: [PATCH] test/statx: verify against statx(2) on all archs
To:     Tobias Klauser <tklauser@distanz.ch>, io-uring@vger.kernel.org
References: <20200709213452.21290-1-tklauser@distanz.ch>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <304e4cdb-f090-ef90-18e1-d677d659918a@kernel.dk>
Date:   Fri, 10 Jul 2020 07:55:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709213452.21290-1-tklauser@distanz.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/9/20 3:34 PM, Tobias Klauser wrote:
> Use __NR_statx in do_statx and unconditionally use it to check the
> result on all architectures, not just x86_64. This relies on the
> fact that __NR_statx should be defined if struct statx and STATX_ALL are
> available as well.
> 
> Don't fail the test if the statx syscall returns EOPNOTSUPP though.

Applied, thanks.

-- 
Jens Axboe

