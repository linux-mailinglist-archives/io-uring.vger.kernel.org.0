Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B802959EBC7
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 21:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiHWTGm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 15:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiHWTGS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 15:06:18 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5024D40577
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 10:42:52 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id c4so10646078iof.3
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 10:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=dj0V9vBjxrXRd/VH7UbNkqJmV3lGrQEy29eZYEFgKEw=;
        b=d1AqPL+6z/zUCez5sJAlJv3Ul3MZHzeWBb3kE74yBeY7aEiP/SLWTR+HwPkXJvDyWG
         aRiB31jZaMVvkffWfFjxTxQzyc1gUg0iOotdZz70CpwHPvDJ8py9gCEdx8DTPpMAhBJW
         ILP4Kjhqn3tdamyl1q134oq2/Xzs7ksEgvm7vu43OTYPaLPqyUy+Dk1Dks9jG717yruV
         wbfFj7Xmgz3A+z2F11wp7DEu9v3pGWmeov0oYMI/Wc9PSzMUyYlWd5X55ZqVwV4cK4Lv
         1zN/0Ae19LWt/Im+gsNkUwt4NavM81yEaoiw0rSObEwHE6A9NVEMVAPKQA8XwBFSPSqh
         /o0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=dj0V9vBjxrXRd/VH7UbNkqJmV3lGrQEy29eZYEFgKEw=;
        b=uG+Nb13szuDZhcSj5n43paQImemwvbKx5JP6of7c3mhNOwXnmBBu2riKKtb3xvdlP/
         o47mNyZHkQUOfRqUoPz4QfnVYXEZ/kcd2mRDQABn1+CZwS1AUcxVCJFnzpYpBrPyxwEA
         7DEuFWttt8QFw7LDohKAEhzgeIGZKzoScmfMx6vZLvUpulSt3NyM/zKnk/BZ5hdbekrq
         fEwWmRlBZuKeHgk++ObynXLda1HSQH3SZB5Rdx/jDS9rUj/Sq4ihorbkCkFICjYjZxcw
         yExdAuOBKR4XbFBB6syEtjshYpSmOzeaUlWhvgvWDOJBrpju8adkKP2EznTav0wnzSnG
         Fy8Q==
X-Gm-Message-State: ACgBeo2yAjoKegbgd3thZ2BxzA3zw5sMP06UGj8uEGrUsB/2rz210suS
        J8B5MNvPfyUDJ6Sw4F98MCfTVvO2BkYZ3g==
X-Google-Smtp-Source: AA6agR7cYrZ0JIABleSQS8i7ZByLwpXdwjmtzwUYH+slkev3xN9ReOPkjJ9RKJo7t7BzfWAD2sq1BQ==
X-Received: by 2002:a05:6638:4784:b0:349:ec6c:e133 with SMTP id cq4-20020a056638478400b00349ec6ce133mr3273935jab.1.1661276333337;
        Tue, 23 Aug 2022 10:38:53 -0700 (PDT)
Received: from [192.168.1.170] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j131-20020a026389000000b00342b327d709sm6489562jac.71.2022.08.23.10.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 10:38:52 -0700 (PDT)
Message-ID: <4f341855-5c3f-ed01-7d63-fabfbdd4d952@kernel.dk>
Date:   Tue, 23 Aug 2022 11:38:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] io_uring: fix submission-failure handling for uring-cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        anuj20.g@samsung.com
References: <CGME20220823152018epcas5p3141ae99b73ba495f1501723d7834ee32@epcas5p3.samsung.com>
 <20220823151022.3136-1-joshi.k@samsung.com>
 <ceaf9d3f-7588-a64c-0661-79133222f443@kernel.dk>
 <20220823164716.GA3046@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220823164716.GA3046@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/22 10:47, Kanchan Joshi wrote:
> On Tue, Aug 23, 2022 at 09:47:39AM -0600, Jens Axboe wrote:
>> On 8/23/22 9:10 AM, Kanchan Joshi wrote:
>>> If ->uring_cmd returned an error value different from -EAGAIN or
>>> -EIOCBQUEUED, it gets overridden with IOU_OK. This invites trouble
>>> as caller (io_uring core code) handles IOU_OK differently than other
>>> error codes.
>>> Fix this by returning the actual error code.
>>
>> Not sure if this is strictly needed, as the cqe error is set just
>> fine. But I guess some places also check return value of the issue
>> path.
> 
> So I was testing iopoll support and ran into this issue - submission
> failed (expected one), control came back to this point, error code
> got converted to IOU_OK, and it started polling endlessly for a command
> that never got submitted.
> io_issue_sqe continued to invoke io_iopoll_req_issued() rather than
> bailing out.

Ah ok, yes for iopoll it'd make a difference...

-- 
Jens Axboe

