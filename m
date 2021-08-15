Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8C73EC9E0
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 17:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhHOPR4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 11:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhHOPR4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 11:17:56 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFB5C061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:17:26 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j1so22661843pjv.3
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=q3DdQLHyWq/Q0TvwUNx/Zernv6JkW/kg3KJxIeZjDkw=;
        b=NrEfXuPMOThX3E+HUXTugvQB2xUH+qU0nPCciusZnF8/+BSr/ZAXBMYN5n77K1CVbd
         FtBnV/6rDtdyaAy+6RUWxY0cc2ZwYct+iQMTlyDobmMOeaH5EqrXFaNep4kXqANCUVUP
         LNoJH3nIdywYVIgO+jXfzdkMWY/vcjGQMCw1uXF3YZfKfYlwY/TzTeTHK/JsY4CLGP7P
         ZhTM9P26LZxH3Io9sLFlDVcoTBAtSmek/GK194/F/KK6TQ5yRHKoAMNCYJhxUVcYKyAc
         i9rkmybQqzBMM8pJIbN7YkWtt8Ea9uYgbYtfGAaElmHSzR6hJWNj/BzEM+yAWgJAAMfw
         am6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q3DdQLHyWq/Q0TvwUNx/Zernv6JkW/kg3KJxIeZjDkw=;
        b=LXCYzmbjoCqE/dIy+bKY4n23P32aieA7j4CrfBlpDIe2fi0xndEjOcrmXVtRUiOiUB
         1FWUfu7kzY2D7nOrlqpXxj0bG2hhZU6wTewkx3t9D5EOTFNlpnl2yWxGV7tHUuzIFgnh
         SL2Tkv6wJPNrx7xPG/YWrz6oAow084Rlg365M9hW04gtpG6z576DkNXgzu0D4Izw0P76
         zeCVoDhGwVjEJvcb4gF1nIC7G22ABiePzqWRFchXZBRjPuMpnrHYAqJcrtH0XFI2932k
         8I7qqBWH0Jyvrfm4kiqGcyyub4ECCE21HRi78qIqfu/leEUZiTx86Zhf4IcdAsUKMfwC
         wllg==
X-Gm-Message-State: AOAM532G0spqJQfbDGA7dgd1kgDskSY1XS9vD0CvQNbDUIcfu8rDYqJv
        RK8A4wtdc1NcB4h6eKTPD3N/mizOxRkNzPt1
X-Google-Smtp-Source: ABdhPJyoQ+bOsSl/iMYG5MPmXL44xD3yn2/YWbRDVy4Ftrnbwck/dF403HXxxopqWpPD2wFUZmrsAw==
X-Received: by 2002:a63:fe41:: with SMTP id x1mr11577209pgj.272.1629040645484;
        Sun, 15 Aug 2021 08:17:25 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id l14sm6878727pjq.13.2021.08.15.08.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 08:17:25 -0700 (PDT)
Subject: Re: [PATCH v2 for-next 0/5] 5.15 cleanups and optimisations
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1628981736.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7be195de-544a-e1ee-fef8-09738adfc820@kernel.dk>
Date:   Sun, 15 Aug 2021 09:17:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1628981736.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/21 3:40 AM, Pavel Begunkov wrote:
> Some improvements after killing refcounting, and other cleanups.
> With 2/2 with will be only tracking reqs with 
> file->f_op == &io_uring_fops, which is nice.
> 
> 6-9 optimise the generic path as well as linked timeouts.
> 
> v2: s/io_req_refcount/io_req_set_refcount (Jens)
>     6-9 are added

Looks good - applied, thanks.

-- 
Jens Axboe

