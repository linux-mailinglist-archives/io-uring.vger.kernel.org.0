Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2618A665FA9
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 16:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239288AbjAKPuW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 10:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbjAKPts (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 10:49:48 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9511275B
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 07:49:42 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id h7so7506611pfq.4
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 07:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6ycOerr/aEx+v9Ada9LZlK6tCoMM6V/ehhC7t1tUbgo=;
        b=MD5bkvz0skPZeJBZGc9MQ0ZlMDiBW+sqlmnAdm5tQIr9OOqYlpIolvC6NY6CDErTAI
         QKp+oE9GEI/Onlto5VN8rwGtbBmH8ptefYj/66LXNjIotsPTs1HmHCLu5Hc8L8piOrV/
         m+5LDuLsmg9ob8VGV/SGKYDhB9s+uE+8Gif2OriPIOAA/b6eV16hbhg5uAg2HDzT+qeJ
         pYn49zTyyZ4uIq1WJRTsJmJciyF8oBxAtM7FNvCcQlHRKK87J4yRWVEsqKdgnpygFyZo
         9YKkuiI3psDW58Gll0l7enz7PpJ+t/JY00L34AsQ1LKwuCZHcMZttCJjXEUFHLqjqZxS
         h6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ycOerr/aEx+v9Ada9LZlK6tCoMM6V/ehhC7t1tUbgo=;
        b=N7mE1rsHDOgpzfY25rZ8zMBOvZaPdoSuZPJzyP/uVxF9KNYhTndm/1u7VPKmWe/1dT
         IndhAhAkCqRCcdZ4oW4LhX0Clv8Hw5+aNcEmeFm+tlhDCA/kT8dpvPJEG9DGQ85pt6sE
         wdzC0lTe3oc88xa7qgWvP57VVwCXo6imN7PeHYV3/m7ImH1x+xSdzZ9S4Mjd0aOxmZni
         4f08IBVuE4d5Yn3cQTwdNqzbnHDJde20yhBm23LrdbH0T8AfF6DYCkn/2QYNPINFw0LM
         FbN5Yblr3eU7nc+x3GmTr3Zodq6mWnWDVMAa1eqT+tt1eCq9bUh1aH17oTtDCQNsmZ/J
         VtjA==
X-Gm-Message-State: AFqh2kr4RR6kxtkFPnWt1lpBdFc+Il9+i4G7yqSARzAqTyTrd76xLpPC
        JHvJigHGNsd2aACp71OvftqlgQ==
X-Google-Smtp-Source: AMrXdXsrvowqEvLvvACjvMrU7UfGkolU8ZhQx123nevgkkJ+m87MpeMjB4jnrwB4oLUoUTpb3UGZ2A==
X-Received: by 2002:a62:1996:0:b0:582:d97d:debc with SMTP id 144-20020a621996000000b00582d97ddebcmr6264450pfz.3.1673452181619;
        Wed, 11 Jan 2023 07:49:41 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e11-20020a056a0000cb00b00582e4fda343sm8589222pfj.200.2023.01.11.07.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 07:49:41 -0800 (PST)
Message-ID: <d11eed78-ec21-791f-4dcd-edc6639a98b5@kernel.dk>
Date:   Wed, 11 Jan 2023 08:49:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        David Ahern <dsahern@gmail.com>
References: <Y77VIB1s6LurAvBd@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y77VIB1s6LurAvBd@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/11/23 8:26 AM, Ming Lei wrote:
> Hello Guy,
> 
> Per my understanding, a short send on SOCK_STREAM should terminate the
> remainder of the SQE chain built by IOSQE_IO_LINK.
> 
> But from my observation, this point isn't true when using io_sendmsg or
> io_sendmsg_zc on TCP socket, and the other remainder of the chain still
> can be completed after one short send is found. MSG_WAITALL is off.
> 
> For SOCK_STREAM, IOSQE_IO_LINK probably is the only way of io_uring for
> sending data correctly in batch. However, it depends on the assumption
> of chain termination by short send.

That is the intended behavior, maybe there are some cases where it's
not being set and req_set_fail() not being called? Do you have a test
case that I can try? If not, might be easier if you poke at
io_uring/net.c:io_sendmsg(). If we send less than what was asked for
and we don't retry, req_set_fail() should be called.

-- 
Jens Axboe


