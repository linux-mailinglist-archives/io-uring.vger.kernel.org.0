Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B130251E053
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 22:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443621AbiEFUyh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 16:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443700AbiEFUyg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 16:54:36 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835A66D3B0
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 13:50:51 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p6so8019280plr.12
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 13:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=svtm70vhrtwaUzMmCsUIT6Egi2IpF5lFJHBTBSUBifA=;
        b=k93eJcUdX4CDEojINJyEsXxp6BPwyVW0KU81y0Fd5DXNq0r3T3Jeg9kORS0Pslclu7
         qQBednLjdPTuAgXRX8k+dnJCDa38FqSlf/fRGoognCApgzR9LJ39k0X0tEdOwsDj+Yk8
         yHioi/AfZUJFw91f/azWral+2pdGQm7lPu5MIXCzuw0I0Ymd6euxNkkwrXuaDqZ4L+Mh
         iYnM61GI/pQVI/bY3g1GcH4dzeEYDnTewGQh1mJciqNVDJwWZwDGklWYX9KazGwqBNIY
         EX0Wzq83DRzhpKoeoPLOo6N6t49kYd+3kj/9udQGiIOnD/GwLKnQQdkMlmmc7NAtZ4kR
         Xmfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=svtm70vhrtwaUzMmCsUIT6Egi2IpF5lFJHBTBSUBifA=;
        b=yzn5ATyO6cbRbXX0ga6xCNwMOzecLpoILm85Neq4FgOVznvMjCY+DJkbRTqdvb7P9B
         be2uGfE9UVfljAJXxs+53Tz5DkAKKOZ3EzCZWIODoFAnx+cIjMb/fOJ/mz/XqGZJA6+5
         thRH7tlAYFGpgAakh4E+EBuEXAy3/Na6KXLThlYgc9gpIL8Lxg/raW6wlWFRjKQx8xEb
         UM2kWS50JKWoo8xqqxtSAWFK+9r4FF3lcYlKijqCpn7JzPqJuksDJ7uwhcR9KK0pskLa
         n5udxwK0gMGsM1N7f5uyPxInFSEKkbUtbB5+s7LdACbdWpjcLnS0aC4CPTuUWDWcR8KN
         UyPw==
X-Gm-Message-State: AOAM531dCT+oAwu+Etlnh/9+BsLs1w6iwZPoZxQK9ZWeA3xfZ+Z4zYix
        MaeyA6NYYjXJyEqc/jkpSvjS1w==
X-Google-Smtp-Source: ABdhPJzopfreODKpfWBSy4m9Jlxx414DAMKUaiFGwW300IDx3Eid79W0qvrPDksQwXeQ4gBlT/S2oA==
X-Received: by 2002:a17:903:32c4:b0:15e:9f30:75e9 with SMTP id i4-20020a17090332c400b0015e9f3075e9mr5560293plr.123.1651870251011;
        Fri, 06 May 2022 13:50:51 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id g5-20020a17090a7d0500b001d7faf357b7sm7880977pjl.4.2022.05.06.13.50.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 13:50:50 -0700 (PDT)
Message-ID: <3b302e60-cb5a-a193-db13-5ca0ef5603cc@kernel.dk>
Date:   Fri, 6 May 2022 14:50:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5/5] io_uring: implement multishot mode for accept
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-6-haoxu.linux@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220506070102.26032-6-haoxu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 1:01 AM, Hao Xu wrote:
> @@ -5748,8 +5758,12 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>  		if (!fixed)
>  			put_unused_fd(fd);
>  		ret = PTR_ERR(file);
> -		if (ret == -EAGAIN && force_nonblock)
> -			return -EAGAIN;
> +		if (ret == -EAGAIN && force_nonblock) {
> +			if ((req->flags & REQ_F_APOLL_MULTI_POLLED) ==
> +			    REQ_F_APOLL_MULTI_POLLED)
> +				ret = 0;
> +			return ret;

FWIW, this

	if ((req->flags & REQ_F_APOLL_MULTI_POLLED) == REQ_F_APOLL_MULTI_POLLED)

is identical to

	if (req->flags & REQ_F_APOLL_MULTI_POLLED)

but I suspect this used to check more flags (??), because as it stands
it seems a bit nonsensical.

-- 
Jens Axboe

