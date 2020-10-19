Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4B5292837
	for <lists+io-uring@lfdr.de>; Mon, 19 Oct 2020 15:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgJSNcM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Oct 2020 09:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbgJSNcM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Oct 2020 09:32:12 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F664C0613CE
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 06:32:11 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id j13so42328ilc.4
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 06:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6hKDM1NrBWgYDCELDAw6/G6kNNyxVGaHpvW/Mp+d0vQ=;
        b=q8S/uIdHXWfwfj2/y2xZbOtQZTwbnlAOBeJxWQLxdd07dCFvZKnCIDoB2rpuqUoTuJ
         eXwUAUu8MVRuXSEAVr1CyiXHeXAQUGsdzhc2cbb6zQ7NbSep40FOzBHvZhyOD/vgWtCo
         07GOth+gKv0Gtdolm3Gd+2XE+sYyMUgk69QAOjWWTH9gc2o0OTAOrtZpgUL6OqM71VD3
         Aj7RIkdvqf1chT5MUldBNx/o6EW4n2djbLDDxcW0fezH5/c4mlg0pCQCe9yA/DzJ1/H8
         UBji27rDXnQDh4K5bC84rJwhdScRUG6jvtPtPtU3hRLtDLH2wOvHZwAzaAxeKWXKbvoi
         X28g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6hKDM1NrBWgYDCELDAw6/G6kNNyxVGaHpvW/Mp+d0vQ=;
        b=sXY0YvEWBIxm+Yxz+30ibXZ+c28PQ6psuGnqF1I+12XbiZNZHcsU4V/b/C9fgvF2dA
         GamyBMA/SKBAjmpO1Hjae5SAxKhQNJISx8lTWeiSI6cWksNK93SNobz80wX/cnAZ1p98
         /yjJoKiY1Ph42iyeB4/181WR4fpsYvQbDx4d8V4jE22puoH68Y49rDG7Jo7imgQZXbHj
         mzAIALjTS4/s2sW0bfpOeZgy1ddxku9x5N/bqbV5NddpO9cdm3T0hJ+n+ljKgARjXCcO
         kxE/5CWo5RNALngL0Pl2NaCWjvOXRBs7Puthq2ksN0fk65UPXpEDukRDvlIxlaX2nlHI
         rZPQ==
X-Gm-Message-State: AOAM531wv+pX7z2LyXX5GwTsEWSPfFa/OicOrHEP8nnRpSVYSGBCXKrN
        WOi7O9UBX7iKPzhJds60G2wbatFx8iRkMg==
X-Google-Smtp-Source: ABdhPJxYH5ovq98K7j2PEotU2CHiH7Z3yXODfUULdO5r2PPndNxdZF4HpoPDy6F3nSXzSKMot8R+Ng==
X-Received: by 2002:a92:7742:: with SMTP id s63mr10667269ilc.74.1603114330375;
        Mon, 19 Oct 2020 06:32:10 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v90sm11744798ili.75.2020.10.19.06.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 06:32:09 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: use blk_queue_nowait() to check if NOWAIT
 supported
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com,
        xiaoguang.wang@linux.alibaba.com
References: <20201019084737.110965-1-jefflexu@linux.alibaba.com>
 <20201019085942.31958-1-jefflexu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <87a24029-b148-857a-8387-9e19b10badcb@kernel.dk>
Date:   Mon, 19 Oct 2020 07:32:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019085942.31958-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/20 2:59 AM, Jeffle Xu wrote:
> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") adds a new helper
> function blk_queue_nowait() to check if the bdev supports handling of
> REQ_NOWAIT or not. Since then bio-based dm device can also support
> REQ_NOWAIT, and currently only dm-linear supports that since
> commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable it for
> linear target").

Thanks, looks good to me.

> Fixes: 4503b7676a2e ("io_uring: catch -EIO from buffered issue request failure")

Removing this one though, there was no other option back then, so it's
not really fixing an issue with that patch, just updating the code in
general.

-- 
Jens Axboe

