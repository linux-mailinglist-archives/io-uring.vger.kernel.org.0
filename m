Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EBD21E4F5
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 03:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGNBIa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 21:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgGNBI3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 21:08:29 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B983C061794
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 18:08:29 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d1so1047766plr.8
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 18:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0UDBsOmZ33D1jxEA/FhoZCPCt2o2bA5IJ1Yx0QIpJv8=;
        b=svBxC2pHFv0oOInJ5KG3TN7I2C0/vQ/GW2X7lZe+ra21V61maz0H9iihEiCeW63kDU
         nmSX/ctT9WhqVoQGf3aHV7dbp+o56tvBedbuX1JuIq3y3vq7tu/0TWhtAZ8TBAnpLQDM
         uNtRaryp5hIvgS3cxVY/iz+Y2yy2RxoaksFl5mnpgSvHE10v4E8u5xvIYBD7wgzrW8I6
         LOE/c6BZCknMANK6AnKqZjm9sFAzV4zQfacS6rbX6Ps6puLFfkTR6mxzMNrjlePGVBp7
         xuIZb5lsizlR1qOCiR0UpSQvbGUmrAkrCt+SJ8kCFDoimgiBBlIUG5kCHiXm4xAsbKrq
         LENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0UDBsOmZ33D1jxEA/FhoZCPCt2o2bA5IJ1Yx0QIpJv8=;
        b=czinevQ2YPjRwCF1spmeYmDdPtvbQXDFaQilzmm/Dx6tcu+jqIfF1Tc/6xSE7cEMHT
         +cs2QDb8pbbCrURRxiIPOhTe0WkIWGSItOzHgwwWrFeerjv3Eb2HbV378egiRXkZOO0y
         LqEentfXgodh4LSDjRz0l5Paj2pczkwDMgnNKhmBsQ/cADaDmS/Fed1T8CzCcwwdlPB/
         oQJohUNNS11vUqnL51ff4MDdCkngdRQh3NJwK5oa2wX8gWEIXNv/aoO+vmJU8VWu6Lcu
         WJ+gyWlk8ZSFQwVuBQkdMroPGi+8vUevisa3BBZmUFtzwRLMtErCO+Uw0gygHpuHeIi1
         3d1g==
X-Gm-Message-State: AOAM530VJiqEwC41W4dLUjuH9bGL4QLvSWq62KxWEqKP5A5+lccFg7FA
        piKwosdriUOs/LZSYhHcpQVZCA==
X-Google-Smtp-Source: ABdhPJyGU03phPN5hAdUXP+3DHWo3YYYwZykKV/+KVf+6qeI90BOcAfVc/BDf3l4/D5FeZVDhDj7yg==
X-Received: by 2002:a17:90a:240a:: with SMTP id h10mr2118382pje.225.1594688908417;
        Mon, 13 Jul 2020 18:08:28 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p127sm15779479pfb.17.2020.07.13.18.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 18:08:27 -0700 (PDT)
Subject: Re: [PATCH 0/5] batch completion + freeing improvements
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1594683622.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fc03ea42-8f83-1a49-2ea2-9697c797e76b@kernel.dk>
Date:   Mon, 13 Jul 2020 19:08:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1594683622.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/20 5:41 PM, Pavel Begunkov wrote:
> Different batching improvements, that's it.
> 
> Unfortunately, I don't have a decent SSD/setup at hand to
> benchmark it properly.

I do though, but I'm not seeing any improvement with this, whereas
some of the previous series made nice improvements... If anything
maybe it's a bit slower.

> p.s. if extra 32 pointers on stack would be a problem, I wanted for
> long to put submit_state into ctx itself.

It's getting up there... But really depends on how early in the stack,
so 32 could _probably_ work, though usually batched on-stack counts
are a bit lower than that.

-- 
Jens Axboe

