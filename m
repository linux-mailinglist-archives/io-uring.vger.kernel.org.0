Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1044B7484D6
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjGENUq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 09:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjGENUp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 09:20:45 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B48170A;
        Wed,  5 Jul 2023 06:20:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51bece5d935so8545697a12.1;
        Wed, 05 Jul 2023 06:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688563242; x=1691155242;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/fCmZ6q0JsTV3HqLdUkUdemQX1a9SwOUpIkbbiSyfp4=;
        b=X2FSPgufdbN4hFbJcpyGYdhzQUpCHGEhuczPN84EtUoXlzbP/H/ZaS+MKhsvL8Yd5C
         hPFFBlDp2Q8JMKa0eLDKdCfiDFtLp0OsAgVUUwxg17kgA2bDC2TkIcV+fz4scQJkFWHH
         8jRi28zlpfLjzpAt1oXPjSw/ozRyVBCadkIz2G3W+rkfXcuFSgJJZsPIl6pauC5qQ5MM
         hP+HPGoa+/zP3uK5sj2SCD2f7mu0kfmr2cbWLn5R+Idy0FIafriTkEguMKuzOr3tzlNV
         2eJxx+OCYI44X3aR7praqF5ajwC7YlhE+FMzbxJYfcqw3krNCNN3RFEgIq/eKMuoIX+M
         6hyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688563242; x=1691155242;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/fCmZ6q0JsTV3HqLdUkUdemQX1a9SwOUpIkbbiSyfp4=;
        b=f9nuj8Hd+CExRWPC2kdDUP3DX82KacFjuZu/QhLnRwG6cftwYuy9+0KETBA9E7jVB6
         qRJ+8cQqcDrIGfPhooaJ6t/xhCZYCPh1uKbgHWN7aFpS0lEo9o1beqgpPbKCe/gDUViH
         L0OWti+flWgkFsNsXSjTpVj7fIc1FdUEgmLftVBiO5vxkphFVn5B3ykUGzYXVCkio0i5
         Jw+ZRB0oNGgAoq9qZnqfM5jtJLtknrMWgfhiQ/NjxLfx6L5QjyNUTzHOJ9PZOP+dR/+0
         mdy51gsld5oFQOyqGtPiQvgcPTXJg9juDkeCGRT9wPfT9WX58FCphRuPNFlvfiGnhTJ9
         8Hxg==
X-Gm-Message-State: ABy/qLayVzyxo3624oLZbPkN34V3KlSuLsgxoR3c+FTGeAtIjXOZU/9h
        wsEdvwsOvWN0zopWI6tUETo=
X-Google-Smtp-Source: APBJJlFu8ivEKuBQE21vjIOZHmBdoeVUEin6/EI9cShkYzBlJKRykMMlrV3EaYDLh+btejVe9rDAYw==
X-Received: by 2002:a17:906:ee1:b0:992:c40e:3c1f with SMTP id x1-20020a1709060ee100b00992c40e3c1fmr12331565eji.25.1688563242020;
        Wed, 05 Jul 2023 06:20:42 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:4b35])
        by smtp.gmail.com with ESMTPSA id x6-20020a170906710600b0098e48ad11f2sm13122173ejj.93.2023.07.05.06.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 06:20:41 -0700 (PDT)
Message-ID: <4aed6b48-1911-613d-8e78-fdafd99835fe@gmail.com>
Date:   Wed, 5 Jul 2023 14:17:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 11/11] io_uring: add IORING_SETUP_FIXED_WORKER_ONLY and
 its friend
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-12-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230609122031.183730-12-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/23 13:20, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a new setup flag to indicate that the uring instance only use fixed
> workers as async offload threads. Add a work flag and its code logic as
> well.

Do we need it? What is the effective difference from limiting workers
to 0 via IORING_REGISTER_IOWQ_MAX_WORKERS? It sounds like it should
rather be a liburing helper instead.

-- 
Pavel Begunkov
