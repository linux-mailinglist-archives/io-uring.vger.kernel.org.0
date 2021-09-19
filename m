Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B22410BDD
	for <lists+io-uring@lfdr.de>; Sun, 19 Sep 2021 16:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhISOZk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Sep 2021 10:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhISOZj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Sep 2021 10:25:39 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA49C061574
        for <io-uring@vger.kernel.org>; Sun, 19 Sep 2021 07:24:14 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id h9so15735275ile.6
        for <io-uring@vger.kernel.org>; Sun, 19 Sep 2021 07:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3rE1ZwO4fKJBeodqd/3SHK3HclO829GJvD9cqzqKGjI=;
        b=1x1MWRqYyDTHx+Jl2WTA+PQgQb7ArXfZEBa8zWYsSqvqhZ8jBke2hm4VtKf4jMFcIr
         arIEyVJabBaPI3N1UgC59sIuTNxrpEqbImUgeVvvRonwqLEnw6uFXkv0/2UH9itDhtzH
         03eC0rBYHMFgEg8iAhJc7FCT2rp6XPgAXlVWphpbtexugHzS6qdS7/EpCikfFRLYPHM7
         OF8wmPQwXTsxUVKVX2ezX5QpdpQN2PNkHPnlncadGdVX4XXLpX6aUvRamwNizBAOL1ls
         m0tGLMIDNrb4zTvyvjRDg0jp0lEdADCTQwWalcFicfqQfIUPs970k1VF7/RdPG5IRe0X
         JcZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3rE1ZwO4fKJBeodqd/3SHK3HclO829GJvD9cqzqKGjI=;
        b=21jt9/FYaVavsgZuhc5DxGg00oPMsCcvFZXQY45SomRRgy/z5qx+m7mf2533Ku9h+C
         9Q9mj1N4XksekIq716uOEP7+w3wyD0v8xawxN5rE3hpbKHEDZhYe7V+2c7uZ3koj70IQ
         EDvXNn0pwXXrmK6dN8NSHB6qNpXwiqpi/XQ7MI4JtR3hBWvjldBCCKqDulHZ4DInAi18
         5Sjy60e4afq/HbGSd4ci3UZl3+2//edhNWQ2TwLiaaPY6snMjZBo2w6B7gOD2uzMbpNX
         guOYYwI/SdRO7RUc1ex7YC8/EugNxfpRIRsA8RIw//6lkrOHYb0MOO3Q+YXXgSGOkpQp
         +27w==
X-Gm-Message-State: AOAM533F0ASxsPvOPkOwlGKW8KWcSRlqzNg4m+tS9uY931rpLDu/1A2r
        9+/8b063vV5Hb8zpWbG4jZO6eDG9R2oGyQ==
X-Google-Smtp-Source: ABdhPJwhDhGOKnZsZkyLJdVIeYz1yJx2uwqDYGI3K7OA5lDB5Q+udPAZXwNFVXO5w1gAQx9x1qKOSQ==
X-Received: by 2002:a92:d2d1:: with SMTP id w17mr14405111ilg.145.1632061453552;
        Sun, 19 Sep 2021 07:24:13 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id g28sm2164012iox.32.2021.09.19.07.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Sep 2021 07:24:13 -0700 (PDT)
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
 <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
 <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk>
 <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
 <CAM1kxwi6EMGZeNW_imNZq4jMkJ3NeuDdkeGBkRMKpwJPQ8Rxmw@mail.gmail.com>
 <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk>
 <370104bd-b78d-1730-e7f4-6ea7c5ad50ef@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e68eef2e-fe86-383e-b25d-d365931de527@kernel.dk>
Date:   Sun, 19 Sep 2021 08:24:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <370104bd-b78d-1730-e7f4-6ea7c5ad50ef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/19/21 5:56 AM, Pavel Begunkov wrote:
> On 9/18/21 11:21 PM, Jens Axboe wrote:
>> On 9/18/21 3:55 PM, Victor Stewart wrote:
>>>> BTW, this could be incorporated into io_uring_register_files and
>>>> io_uring_register_files_tags(), might not be a bad idea in general. Just
>>>> have it check rlim.rlim_cur for RLIMIT_NOFILE, and if it's smaller than
>>>> 'nr_files', then bump it. That'd hide it nicely, instead of throwing a
>>>> failure.
>>>
>>> the implicit bump sounds like a good idea (at least in theory?).
>>
>> Can you try current liburing -git? Remove your own RLIMIT_NOFILE and
>> just verify that it works. I pushed a change for it.
> 
> Sounds like it pretty easy can be a very unexpected behaviour. Do many
> libraries / etc. implicitly tinker with it?

Don't know if they do, but as long as we simply increase probably not a
huge problem, even if not the prettiest. I just wish we had done this
for the 2.1 release, to avoid people running into this for stable
backports. At least it's a fairly well known (and specific) error code
for this case.

-- 
Jens Axboe

