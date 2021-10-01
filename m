Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB2341F32D
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 19:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhJARgB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 13:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhJARgA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 13:36:00 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9083CC061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 10:34:16 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id e144so12542675iof.3
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 10:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=I8Y+lxq97yXO1gfWOAS0vYgDNFmJPdHtKARxlaMYLXU=;
        b=I6XTY6Ff2ijnfYmLH4V0IEF/32bhK0UDK3Uz8RSp22mAgBsIiRk3mCz6CchG3ZGGvq
         92fJ//NxcLP48kCXYNBy5trAwSZA8ofcJJIttbTM33ONxuf/Pgjxz/GAIvZMtYLCIFhX
         tncxB9kNV6lHgtEvRSL5I1k9lJnUi+LYyY5e0PXSLAM65BQvsjy1OAOjAc6bcdTay3GW
         E3KNc1BAD04jcTYtfDIKvf1DluUl6NS461Y9uu26S97+BDzkrszJuH6YLi2izeymxTl7
         AT3+PwXWI5jej3mt7hEQu/BnZY/DWk2sGzX7dhreavW7RJ7dVyLkKeeYODKL2JTZmiXN
         bdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I8Y+lxq97yXO1gfWOAS0vYgDNFmJPdHtKARxlaMYLXU=;
        b=HWhzXgWn5kqzavPT/AmxZ1k7Zine4UiJm8OYGRiPCSzCrlTVXS4PheP3vjsyVbmfw4
         tiOCZ8vOG+M/J/7bq1sAbf6BDDZo06K67saf6Tfm2fsmd7Z65kV69os0JwSEvMdhfGa1
         qe+HXA4w56QautZZy0bxkiI36m/edlkWCR1DHmoQbBT506sB3EAwtGCGglzw0w7Uf+r5
         mCN5YjZTSgXnQFqp6qc7NtbgOELlO3zNmAtDbX5qJY2Yhzs6rhTlsqoWcI8c9NdVv9Bi
         fwvVyzIqL9XhNQo33aPjkFH16Cf/+O8sqQflUI2UPblESG6KQn+KUwP1oLBnoJP4BZa/
         bPnQ==
X-Gm-Message-State: AOAM533MqBLN7sJDl9GSzqZp5sO5RMMv96IlBtAJw6aoS5m3i2loOv9A
        aEgLSnMo7pg/kmCdj83eJ2iRBhIfK4PI+N1dGd4=
X-Google-Smtp-Source: ABdhPJye6gwfVrZVtX4C2pESxnbS+SD7LlWa+Me3MeOqlKGSzLlQq9OThB5k7tX3MISxT/6Vql2FWw==
X-Received: by 2002:a5e:a609:: with SMTP id q9mr9039492ioi.23.1633109655667;
        Fri, 01 Oct 2021 10:34:15 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y124sm4046869iof.8.2021.10.01.10.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 10:34:15 -0700 (PDT)
Subject: Re: [PATCH 0/4] small cleanups for-next
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1633107393.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8164d340-cf6f-1030-3f42-ec3732370e04@kernel.dk>
Date:   Fri, 1 Oct 2021 11:34:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1633107393.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/1/21 11:06 AM, Pavel Begunkov wrote:
> 1-2 cleans up after drain patches.
> 
> 4/4 restructures storing selected buffers, gets rid of aliasing it
> with rw.addr in particular.
> 
> Pavel Begunkov (4):
>   io_uring: extra a helper for drain init
>   io_uring: don't return from io_drain_req()
>   io_uring: init opcode in io_init_req()
>   io_uring: clean up buffer select
> 
>  fs/io_uring.c | 142 ++++++++++++++++++--------------------------------
>  1 file changed, 52 insertions(+), 90 deletions(-)

Looks good, and I agree on removing the kbuf aliasing. Applied.

-- 
Jens Axboe

