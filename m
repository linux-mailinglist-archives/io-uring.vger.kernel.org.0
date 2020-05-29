Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B071E8031
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 16:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgE2O16 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 May 2020 10:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgE2O16 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 May 2020 10:27:58 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E4FC03E969
        for <io-uring@vger.kernel.org>; Fri, 29 May 2020 07:27:57 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 64so1226338pfg.8
        for <io-uring@vger.kernel.org>; Fri, 29 May 2020 07:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B6FIZp+IHtz5uymgd/cOx3slmUv5uOkxyGhKnfI0lBo=;
        b=aTR1nav2eJlFyzSZdtjlDJRNhtBo26rjh8ixRo7CHRQM2vurrvMqmwAFPPNEUHi94S
         GRyndFJ7DHZseoTS0y/UL4M8uc92fRBEYrNigvCkso7nMj+E2mOopYiZ5Iat2KN8zHAa
         F7mJpDKRcLJMWCL/NCKlFsSS+HXILjjt1C1JkfywBnjaiTyTe1NZ2V+rier2n2vDZ9Ho
         PrEttrSBt6Gw7qCs3rXQ73n1HydIupGpe2S1LC0QHM8NpIBsWlyu3kXfF/bdtBroA1Rt
         jd2VlUufGRlWWG7rMnYDt4idmer2E3XCH2K1MxkBDp+gaenCOkOralVcA2NB+PNdIvIt
         ydSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B6FIZp+IHtz5uymgd/cOx3slmUv5uOkxyGhKnfI0lBo=;
        b=IAgeGspgT0wxDV4+7lNUYa4xl/kOAx1Iopp6txcmwNcKed5oVE3LOVmYegyR2XTgQf
         wydlGRWVUrDTqMi7OsBwoW3/4h4ViGj7TCLv/7XRMa5oYR3JdolvpN3nfVT/4hJKuBP5
         m5eVItO3v7PDXbw9Ja3cpdy51BJGbZVWWrPRr9oocdl2JlcT4wLD0WGZ0dLUfc40t9r/
         OJETmKm/iSIrE0nKtBG8BWv7Q26ZSWmMh0zLWPkdfcRmQVZjI9U5YmlYaAvmXL16cBeb
         cLRUZFUkgRACjEWtuDO/64vSux8szhTAe9Y9rpZlrlpW92RBcHngvxLJ83ozTQc8BFOo
         gyTA==
X-Gm-Message-State: AOAM533gozV5t57mxDKIBv4EM91N5Mz/bHUM2eW7BVhQ5+Ka23KVQ9Da
        vY15AsjLV/O+cN/MR8BJLSxwn3C023B/gA==
X-Google-Smtp-Source: ABdhPJyz2MD6e/m9fR1O34rBMqaAuSMfYq6jH2QU/T62YvLjqR9BMYAmJQvy7tDtUNkYwPZkPdB9sg==
X-Received: by 2002:a65:4241:: with SMTP id d1mr2373276pgq.307.1590762477441;
        Fri, 29 May 2020 07:27:57 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u35sm6937074pgm.48.2020.05.29.07.27.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 07:27:56 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200528091550.3169-1-xiaoguang.wang@linux.alibaba.com>
 <fa5b8034-c911-3de1-cfec-0b3a82ae701a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ff11c9ad-c6c4-0a3d-d77f-7a34eeff1bc4@kernel.dk>
Date:   Fri, 29 May 2020 08:27:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <fa5b8034-c911-3de1-cfec-0b3a82ae701a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/29/20 2:58 AM, Pavel Begunkov wrote:
> On 28/05/2020 12:15, Xiaoguang Wang wrote:
>> If requests can be submitted and completed inline, we don't need to
>> initialize whole io_wq_work in io_init_req(), which is an expensive
>> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
>> io_wq_work is initialized.
> 
> It looks nicer. Especially if you'd add a helper as Jens supposed.
> 
> The other thing, even though I hate treating a part of the fields differently
> from others, I don't like ->creds tossing either.
> 
> Did you consider trying using only ->work.creds without adding req->creds? like
> in the untested incremental below. init_io_work() there is misleading, should be
> somehow played around better.

I had that thought too when reading the patchset, would be nice _not_ to have
to add a new creds field.

-- 
Jens Axboe

