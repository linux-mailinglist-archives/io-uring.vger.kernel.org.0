Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA2B27989C
	for <lists+io-uring@lfdr.de>; Sat, 26 Sep 2020 12:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIZKxS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Sep 2020 06:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZKxR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Sep 2020 06:53:17 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB76C0613CE
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 03:53:17 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mn7so811643pjb.5
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 03:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tHCYM+BiDqwtlNHehOh/PBH/KXQt1NJlXqit8LBZ04A=;
        b=LEko5i44A1vrMDGEEcBhEBlk7Oxr/ePiUfSH21KLjWHVBjIpE/IvLkbuEPpanjF5VO
         3w7sx2w3yJhzIaffxslZ1PGfo6/L+HH/dcmvNPKC+KIaOkVk++8CnIXhwkVOAeK3tpKK
         egIbzK2RSBcoXu3KnmOUb49R61isNC3hgLwiWe+Pt6pw6/+5+P/SC5DxXxu3Vy2fK9Lc
         BbCmIESN9Xe/PrSGH73ketBLfFWWSxQc52y+YJEvihiveFvCHZgapwFP/XB+nMocR5kx
         pygTM9kuwS5MdpCTMYeIPw873zSazW4dCc6ziHEbplDrZbpnOpTR0Cj87kxqGTKhRXaS
         J5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tHCYM+BiDqwtlNHehOh/PBH/KXQt1NJlXqit8LBZ04A=;
        b=eaRP297B0iphrROPK+IFmIPJ5tWPmOzzn7qFmQT+fgapy9YzqHEuF6RJIwEsGAQ9nj
         ZeZEgxYzP2Gwl14Sn7mevkCXT43YiA/7NOWr/MSz1NDSTH6+8aqFeoSFB8j+Lpp8nd2J
         XHyi5TlbUGWKNoONOy/6DIPWYLvE5ZAHOwFmXsAtJjI2sdRw6S6kHEr2/0HWW4+FUC6s
         U4Aqv2ZuQaXy6/+0ishmlIE5r72NEAFSMIEPTTfVTaxFkvw7TYvGzE8Dp1aBIYaSrDSH
         QO3dGWwAPZG0/koM9NzuijYDtANgI7acQSiVZWKLxkXwi62o1009tBarZqaNWpAsxb/+
         Y0aQ==
X-Gm-Message-State: AOAM53372yqyqlwg8E4whn99c+aPNLCfR5fzR5FFn8a2ITzjQOuIIcxW
        9TIuluGec6sKNY6JokGPYwMsLVFM1tTl08JC
X-Google-Smtp-Source: ABdhPJxsAsc19eKxKbQexQBXyLiF14clWxi8LjdBvNCUEznn8gLOujngqvqhpNQSnUlZJha2JV8qMg==
X-Received: by 2002:a17:90a:d3cd:: with SMTP id d13mr1728730pjw.70.1601117597038;
        Sat, 26 Sep 2020 03:53:17 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e10sm4826460pgb.45.2020.09.26.03.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 03:53:16 -0700 (PDT)
Subject: Re: SQPOLL fd close(2) question
To:     Josef <josef.grieb@gmail.com>, io-uring <io-uring@vger.kernel.org>
Cc:     norman@apache.org
References: <CAAss7+rWKd7QCLaizuWa0dFETzzVajWR4Dw7g+ToC0LLHcA08w@mail.gmail.com>
 <9f1ac2d3-6491-bd5a-99ea-8274a8a19e2b@kernel.dk>
 <CAAss7+psYrRTdgbX0hFniUUmuBNTPbzRKGGg7v1E1N+C08FE8A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <46cda4dd-2f7e-67df-1757-3e7f087adf8d@kernel.dk>
Date:   Sat, 26 Sep 2020 04:53:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+psYrRTdgbX0hFniUUmuBNTPbzRKGGg7v1E1N+C08FE8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/25/20 5:40 PM, Josef wrote:
>> If you have a file registered, that holds a reference to it. So when
>> you then otherwise close it in the app, it's similar to having done
>> a dup() on it and just closing the original. So yes, this is known and
>> expected, I'm afraid.
> 
> Thanks for clarification, the only way to delete the file registered
> reference is to use io_uring_unregister_files right?

Correct, that's the only way to trigger the final fput() that'll
close the socket (for real).

> I don't think that we can support SQPOLL for 5.8/5.9, but at least for 5.10+ :)

It'll be a lot more generically useful once we have non-registered file
support, so I'd probably just ignore it for now for your use case.

-- 
Jens Axboe

