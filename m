Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7A01EEF1B
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2020 03:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgFEBdk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 21:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgFEBdj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 21:33:39 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C3FC08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 18:33:38 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t16so2965616plo.7
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 18:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+p9Sh02Daic/Tlvi4Lhr66rHCmy39Ja3sTw5ESe+ZqU=;
        b=Yct9d78QeeB8LPfuY18BjNm5Fwtms/InXYNmfaNnrgpa2KVit0HvJYeKyvdBe4j76T
         csXyL/tzI49W6F5Xhi7Cjz0yQpAGCvJ2kFmJlP3CeEAVMmm5DBu3ESBj2zTxTy7mp6kh
         OuOkkUAPcoRi+ZJ8hQ4+mXSO2+OQkOQo29sD7twQ1lqIjExilHhq19VFgADyQTmsS1SC
         QvC8VtzyA+YcjHPsshUqiCQgDZUFLb1z3MbO5EGrLj0EcZsaVb48KueezjUKS+bV216F
         gLKZ7FfRqZxYH7LQU3r6MFP+UcEXbbgE/N5slSL5YEX9N+W2w5NFItfZHBCHm7UtUW9D
         0rlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+p9Sh02Daic/Tlvi4Lhr66rHCmy39Ja3sTw5ESe+ZqU=;
        b=Ak81pdaQT8PekKJ2kx9yeBSOYKYzzGboPlwRU9VNTS1M8us4UNrp93hFL/XFzvWsmF
         ZtrVQw3etbQxFhfEBXUkiygJXNZ6Qta/j2NfDkEvPeqMmhj+AIY6U9UDdbRbeNJc+61b
         8yvlemv6Tb0fMjiOLDdH75ZrI3F/cudkgKFWb+YtLhC3Uhs4tSAItDZjCnYak5HgQhWG
         UtpTLuOZbCvBL7Cnj7n3yKam1Km1Ma4XWJQG6ZrjJq/Vef0qvnUUeq/16nVjZy9lJLaz
         DkYP4SIsfYq6Fji9+/Lgb9DHcLfusKvPs3mgJFmseb63Jh24d5CSxKEJTUE08NqJo0sq
         AADw==
X-Gm-Message-State: AOAM532YDJIcIUcZTBMxoWW0T6oJiz+XlotV7MCyEPlNe2vNTOZu9LOF
        tOqbPMQNFGYua+b08ay6nwqnK+lY1eKtwQ==
X-Google-Smtp-Source: ABdhPJzJBWJkQxlCjjPgjCJXHaQUpegn9Ufushsf8XWqaZVCVYjeWujQT8mcKH8jbD3eCWkNh2vM2w==
X-Received: by 2002:a17:90a:cb8d:: with SMTP id a13mr172566pju.175.1591320817433;
        Thu, 04 Jun 2020 18:33:37 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m16sm5462521pfh.187.2020.06.04.18.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 18:33:36 -0700 (PDT)
Subject: Re: [PATCH 0/1] io_uring: validate the full range of provided buffers
 for access
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1591318912-34736-1-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7614bae4-4827-9109-ae4b-2ae6b4f5ca8b@kernel.dk>
Date:   Thu, 4 Jun 2020 19:33:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591318912-34736-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/4/20 7:01 PM, Bijan Mottahedeh wrote:
> I hard coded (user_max_address() - PAGESIZE) as the start address 
> in liburing/test/read-write.c:test_buf_select() and provided two buffers
> of PAGESIZE each.  Without the patch, io_uring_prep_provide_buffers()
> succeeds but the subsequent __test_io() obviously fails with -EFAULT.
> With the patch, io_uring_prep_provide_buffers() fails with -EFAULT.
> I think this would be a good test case to add but I'm not sure what
> would be a generic way to implement it.

Thanks, looks good to me. Applied for 5.8.

-- 
Jens Axboe

