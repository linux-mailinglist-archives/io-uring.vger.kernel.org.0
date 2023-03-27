Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B84A6CA5AF
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 15:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjC0NYz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 09:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbjC0NY3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 09:24:29 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A2B35B7;
        Mon, 27 Mar 2023 06:23:45 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id t10so36051907edd.12;
        Mon, 27 Mar 2023 06:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679923425;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hh/IM+UHRneqBffkgUbLi5lZIJUZtOKuvrQyazPYma0=;
        b=Qbju3h85lOm7GzltrAWgCkcahYK2RIUINNaIWnr+UhDD8gQ3aMD2aHxAfcez96lklh
         1oJyTDLk8I+/UeqfAqBf1SIN1JTP+QXsScRiGpIwQ+5kb/2unYYDjM0dLvKxI/mMq84j
         TqMFu+Xo5DW6NAiwlb3+adGnEGjydpIXMMDuE/P9or0uVbz8d3u50j7mnMzxpIHl1xu8
         cdQeFLf4RJEIb2ZDwm4JbgkVeNeYas/YJnQqnaPb6N6i/OlSco6PXKNtTlj5eow3Cm5Y
         Jk6uWGWxxFHHRzonNcmz+aLWxC9NIusHo9tXl+F/6ViVpRE6NcS8a/tHl7JSrcJiLXPf
         274A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679923425;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hh/IM+UHRneqBffkgUbLi5lZIJUZtOKuvrQyazPYma0=;
        b=WQ7zncLXdzgllJJbGeSyMPKSrkIWzWmg5g9xeVNxVdNFMMuYfr468A+l7B30pNHNSk
         94tyoHCQF33JNOKcEq65050O+qdJNH7vPxxzlxpbMT380XwcyUOmaP3CsLl6eSoZUdfz
         go+V7IEp6FcHuaopDgREHwI4v/61JBSzEA33eE2aDS2tBw/k6tyJ4ByVigsmWuOIiV9g
         v0uTDyz3FDegziX5OangouHcqsr2EVQvq7LCdxMFlTAyRimKM/sffxnJHheXm/qhwyi0
         3LUanCHpAkGTv+s1mykAsxMhSV6AtuxXO8c/Nc9tkAZ/IbS20cElrjFCxoI9yoLlHBYW
         oFyQ==
X-Gm-Message-State: AAQBX9d8HEG82kaZUbF9AJ8HjNjGDTeTQCDRx1dHb92yS00ssLIWfitJ
        RDXk/n51+tO1LtEAWZHvQIs=
X-Google-Smtp-Source: AKy350YI+C7OCA8kH8iUdcpJdj98lI9A/waYrW7dZXRKHvQP76HxtRwOEH9jGK5De/IlJbEqpPoFVA==
X-Received: by 2002:aa7:c942:0:b0:4fc:782c:dc9b with SMTP id h2-20020aa7c942000000b004fc782cdc9bmr10608050edt.40.1679923425085;
        Mon, 27 Mar 2023 06:23:45 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:1063])
        by smtp.gmail.com with ESMTPSA id b15-20020a50b40f000000b0050221d6768csm4789777edh.11.2023.03.27.06.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 06:23:44 -0700 (PDT)
Message-ID: <a2fbe689-40e6-c01f-3616-4f42ae14347b@gmail.com>
Date:   Mon, 27 Mar 2023 14:22:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 06/13] fuse: Add an interval ring stop worker/monitor
Content-Language: en-US
To:     Bernd Schubert <bschubert@ddn.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dharmendra Singh <dsingh@ddn.com>,
        Amir Goldstein <amir73il@gmail.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        Ming Lei <ming.lei@redhat.com>,
        Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
References: <20230321011047.3425786-1-bschubert@ddn.com>
 <20230321011047.3425786-7-bschubert@ddn.com>
 <CAJfpegs6z6pvepUx=3zfAYqisumri=2N-_A-nsYHQd62AQRahA@mail.gmail.com>
 <28a74cb4-57fe-0b21-8663-0668bf55d283@ddn.com>
 <CAJfpeguvCNUEbcy6VQzVJeNOsnNqfDS=LyRaGvSiDTGerB+iuw@mail.gmail.com>
 <e0febe95-6d35-636d-1668-84ef16b87370@ddn.com>
 <a1b51f8c-06b9-8f89-f60e-ee2051069a51@ddn.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a1b51f8c-06b9-8f89-f60e-ee2051069a51@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/23 20:51, Bernd Schubert wrote:
> On 3/23/23 14:18, Bernd Schubert wrote:
>> On 3/23/23 13:35, Miklos Szeredi wrote:
>>> On Thu, 23 Mar 2023 at 12:04, Bernd Schubert <bschubert@ddn.com> wrote:
[...]
> Found the reason why I complete SQEs when the daemon stops - on daemon
> side I have
> 
> ret = io_uring_wait_cqe(&queue->ring, &cqe);
> 
> and that hangs when you stop user side with SIGTERM/SIGINT. Maybe that
> could be solved with io_uring_wait_cqe_timeout() /
> io_uring_wait_cqe_timeout(), but would that really be a good solution?

It can be some sort of an eventfd triggered from the signal handler
and waited upon by an io_uring poll/read request. Or maybe signalfd.

> We would now have CPU activity in intervals on the daemon side for now
> good reason - the more often the faster SIGTERM/SIGINT works.
> So at best, it should be uring side that stops to wait on a receiving a
> signal.

FWIW, io_uring (i.e. kernel side) will stop waiting if there are pending
signals, and we'd need to check liburing to honour it, e.g. not to retry
waiting.

-- 
Pavel Begunkov
