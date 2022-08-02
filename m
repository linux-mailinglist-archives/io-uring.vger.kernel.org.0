Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F26458834A
	for <lists+io-uring@lfdr.de>; Tue,  2 Aug 2022 23:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbiHBVEu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Aug 2022 17:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiHBVEt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Aug 2022 17:04:49 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C3645077
        for <io-uring@vger.kernel.org>; Tue,  2 Aug 2022 14:04:48 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id a9so10869942lfm.12
        for <io-uring@vger.kernel.org>; Tue, 02 Aug 2022 14:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=EkO0kSpv9+M7mVPJG/gMBmNsn3eCCfkHdIcNSDIHrIk=;
        b=c4tNd8V28BKlMzOiCkvWPsmFCntVNIowc+lK1eJLdHAMvTPtLI9r89NpRF9WFIhnlD
         +GboysU5dvk7VWjPOZGFnnbsjF7MlavsqqhiCIyVwT4Le7SjXJxsPkNDWMZvr7f/tOMv
         JIefclUu88E/Va31NEEy9aFERJ4FafGiVE8up0JSD8YaB+eafYgV0byRwwgWzqQhBxit
         OJu9KiRB1YD9IwEJJ3grWjcV5orks86iWmT4Jm6gXzR5jSYO9kYyy0DMwdOmjBI/jF8e
         pRk8/PCB4lOnYwsQe9se919X7+Uj3wa2gUdHI4nTeCbtZvS6BGZogIyY4ErpYSyWhit1
         K5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=EkO0kSpv9+M7mVPJG/gMBmNsn3eCCfkHdIcNSDIHrIk=;
        b=YEeQsk83m8OxWtEojqotPMsD3qLNQ0frITzWw2IPQtU6ZZPwoWSJWxBabKFMIpUIWU
         RQywjGRcLADfVujAAdYImq2vjUGGrXVZl8+PMxPDMwpVfF1YUXO6NIZ1k0UhQlvkKdbI
         dWnoWmQlUq4dFaKdBKH++IRKOFxaw86WOcahpmmKY8KA/GKErE6uZ3kTgMr3bY2n30uE
         T/BvXZ/LApxosgZuOqUBL/LtIm/TdaEaIzHt8ng4i7CqcQaqQUsrvFJIX6HPYt9gY7If
         RcCsi6vorPpFRdp45seu1yNSEoNszfccRc2StDpvw/MBv96CT60A9MhFCHcDH89Bxt3R
         4Avg==
X-Gm-Message-State: AJIora+cibp3ce2vCnCFsPaMvocNLc3sQRtvYgq/sqtQy1GbOf44VoBU
        68HTu2gQMG0+0drCLRqe3hgVGoB9tw==
X-Google-Smtp-Source: AGRyM1s7y6rbhmUw0ovQQxOh+BLEhTxvO74zLX/+lpz/izJfprjOqAzWawMNJlC94FebmpkDvTBuMQ==
X-Received: by 2002:a05:6512:b2a:b0:48a:2aaf:2ad3 with SMTP id w42-20020a0565120b2a00b0048a2aaf2ad3mr9001261lfu.552.1659474286931;
        Tue, 02 Aug 2022 14:04:46 -0700 (PDT)
Received: from [192.168.1.140] ([94.103.226.3])
        by smtp.gmail.com with ESMTPSA id w2-20020a05651c118200b0025e01ee7229sm961185ljo.54.2022.08.02.14.04.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 14:04:46 -0700 (PDT)
Message-ID: <b9c90ccb-c269-7c78-8111-1641af29b0eb@gmail.com>
Date:   Wed, 3 Aug 2022 00:04:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     io-uring@vger.kernel.org
From:   Artyom Pavlov <newpavlov@gmail.com>
Subject: Adding read_exact and write_all OPs?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Greetings!

In application code it's quite common to write/read a whole buffer and 
only then continue task execution. The traditional approach is to wrap 
read/write sycall/OP in loop, which is often done as part of a language 
std. In synchronous context it makes sense because it allows to process 
things like EINTR. But in asynchronous (event-driven) context I think it 
makes a bit less sense.

What do you think about potential addition of OPs like read_exact and 
write_all, i.e. OPs which on successful CQE guarantee that an input 
buffer was processed completely? They would allow to simplify user code 
and in some cases to significantly reduce ring traffic.

Best regards,
Artyom Pavlov.
