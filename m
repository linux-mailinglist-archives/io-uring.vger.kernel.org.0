Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C4A2519E8
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 15:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgHYNkg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 09:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgHYNjw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 09:39:52 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A65C0617A9
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 06:39:47 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id s2so12497463ioo.2
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 06:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sCIyfbyLPajZzm/nkZQjt2emAfD5sYHSpzDHfjMkJC8=;
        b=w1Rl3nI/cXGdnXWu3alxiw0NJ1wFgTUZalV5QXU64Q2KIRlV/w9lChPZ7ThauC9BkB
         jCOPhLwKoL5QlQLDmYWmV38PId9QAqwm5PWBOrpcHpVcdf5K25j/T6hS0PMgIB0DAFMv
         Eex7A1m8o9vV7SiXYeQJrt6XziFJ1y06VS5UF5iKiwkRjPKGsqgupRiAo67gudLtMMy/
         a8buIcVe4iSgII7+ZHU5saKlNQ051YlXppdIFWdYgfanGbwSxPahxvCNeVxhjW2MMc73
         O62a4QGzievyivHgpZ9GzJ5Qtw+LOqGYaiglpIRPVuyg3XV9ynAtEF0nk/XijvUn5xKh
         E+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sCIyfbyLPajZzm/nkZQjt2emAfD5sYHSpzDHfjMkJC8=;
        b=OUExv/cK19fK8fUjJMrCxoSIvzU6k6hZoc6CNg8dokOy9V3B+h6tMJImxumiNLatiQ
         pUNkRk/rc7yU43mejXwyFJYXG31McXuNrYP6o/Iy3f94KJrjlpm6TvBs8y/xd7GEJZe8
         VPojWozS6gO6qtwHjd+0tx0r0vxjZNmk5AL+MEhZwEzJfGTyIB7O+3k2nx2PoGFNYFvT
         2A+et8ggvyOhvwaft2tfuAQ9EEDAvXIyub7ufQP0ofHosy9gQW/toa1M9yF7Ea7MBOoa
         abadvbre5MOv9S52CKAFyPGqQXmjlaKOrVQDmgqTYCwzJFmzQ1ppMHahridKyfLyU5QA
         ZBOw==
X-Gm-Message-State: AOAM5303I6xI1CJw/+3oXwsiCJdnxZPWQ9kGFu8EKMqmaX/XyHSASglm
        LCwTCl7G+Ibm2Y0mmWhdjg6d5oOP1hIf39ee
X-Google-Smtp-Source: ABdhPJy/ZFiOKpbFt42693LluWDkD1pLd9f8iHGWXTyQphuIgWXqFQLgKT9vMF5qqmAp7H/jflGCpA==
X-Received: by 2002:a02:c919:: with SMTP id t25mr10791172jao.38.1598362783717;
        Tue, 25 Aug 2020 06:39:43 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s13sm9132811iln.12.2020.08.25.06.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 06:39:41 -0700 (PDT)
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
To:     Dmitry Shulyak <yashulyak@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk>
 <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
 <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk>
 <da7b74d2-5825-051d-14a9-a55002616071@kernel.dk>
 <CAF-ewDrMO-qGOfXdZUyaGBzH+yY3EBPHCO_bMvj6yXhZeCFaEw@mail.gmail.com>
 <282f1b86-0cf3-dd8d-911f-813d3db44352@kernel.dk>
 <CAF-ewDrRqiYqXHhbHtWjsc0VuJQLUynkiO13zH_g2RZ1DbVMMg@mail.gmail.com>
 <ddc3c126-d1bd-a345-552b-35b35c507575@kernel.dk>
 <42573664-450d-bfe4-aa96-ca1ae0704adb@kernel.dk>
 <CAF-ewDqffa=e-EBOdreX9S7CXagM-ohQSsyyDMooDR83W9kjGg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8076e289-2e0b-5676-aaac-eff94245a298@kernel.dk>
Date:   Tue, 25 Aug 2020 07:39:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF-ewDqffa=e-EBOdreX9S7CXagM-ohQSsyyDMooDR83W9kjGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/20 2:52 AM, Dmitry Shulyak wrote:
> this patch fixes the issue with 0 reads. there seems to be a
> regression that is not specific to uring,
> regular syscall reads slowed down noticeably.

Do you have a test case? Related to specific system calls, or just
overall? My initial suspicion would be Yet Another one of the
security fixes...

-- 
Jens Axboe

