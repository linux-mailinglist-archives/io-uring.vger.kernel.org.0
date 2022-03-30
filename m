Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9B64EC7BF
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 17:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244979AbiC3PHk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 11:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347797AbiC3PHj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 11:07:39 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF8692D21
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 08:05:52 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id y16so1144786ilq.6
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 08:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KKsohv8BmPb/plCq9PZ6CRiHxr+CmY79A7FQns1Dv+I=;
        b=kdhS6P/jZrn47zbiMaC+kRXcpAyhXfL3WTkpBtjxTlvErDUJw3DabT5J6j0vHKoPCA
         fXjJ2BSVpfWH40KOonSG8reAsp2pmm7EhTX+CQMXPWwd/632NBNDm4En0e7zB7oNad+V
         xDnlER5Nh6qOJdkEz1GpDms5qcJ3wR1wZvN8eeZ5vBcU+aCTnU5C/j5BPRCo2J33vOqz
         BXVpf992hgSBWVvSnLS0Fblw2aJEUURCP0UYcz1M2rTA82C2PL3yNS2s/WBP4f0/GbtD
         W1+kvTZSBXzBCxUzWZxnUPEjRzjxvYPIrYB65mYFFHvXFVpAvchytEKX8X2SSx25VgY/
         2bAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KKsohv8BmPb/plCq9PZ6CRiHxr+CmY79A7FQns1Dv+I=;
        b=AgpD32vDCtPwKzG/bFxBdAIYbUOGMl55Rav/J0osjmkimuWwvP8QHuk5KF+CDCiP4d
         SOcXZAYZ3JPakAY0cJvRdMnZMcN6xhF/3vZbV5drdV7WPpMJ1RudoODOSy1X+FdsSyzr
         Afp8eL39DdGg2B2SWsB1hqaZ5QYmZIXh5vwX/a+BkuuCDe/bt3RPNXnvf9qg9KzxZf1S
         rVmENtMqGkVoolJpTZ+WwZT4e7GmRYaSGMoklwFYqGG7DeG0t0/VH73OaLBIY1FIQNcN
         FIybD0f1fDDQnmtWXrJAtjMXRs4MixUCX1qL87Qw9SQBV87/gmFGUUsjAAb58PXQqMbB
         dtfQ==
X-Gm-Message-State: AOAM533eTrM/dFhOvcxwELixfDlbwtc9MQf7t8OFVV0Of/jVSfYuS7rd
        HVfznm1OtrXt0CagFzs0XpIInHExZJg2OBJV
X-Google-Smtp-Source: ABdhPJw/wkA8/4l1yoD8UX8wNlvBWILUKFrBNbEqQjn+IFPKDzeXXagLDia9+VswAU4nE2+ilmO7+w==
X-Received: by 2002:a05:6e02:1a8c:b0:2c8:3c9:fd21 with SMTP id k12-20020a056e021a8c00b002c803c9fd21mr11240944ilv.120.1648652751504;
        Wed, 30 Mar 2022 08:05:51 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c2-20020a92cf02000000b002c9ae102048sm5786705ilo.77.2022.03.30.08.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 08:05:50 -0700 (PDT)
Message-ID: <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk>
Date:   Wed, 30 Mar 2022 09:05:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk>
 <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
 <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk>
 <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk>
 <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk>
 <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk>
 <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
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

On 3/30/22 8:58 AM, Miklos Szeredi wrote:
> Next issue:  seems like file slot reuse is not working correctly.
> Attached program compares reads using io_uring with plain reads of
> proc files.
> 
> In the below example it is using two slots alternately but the number
> of slots does not seem to matter, read is apparently always using a
> stale file (the prior one to the most recent open on that slot).  See
> how the sizes of the files lag by two lines:
> 
> root@kvm:~# ./procreads
> procreads: /proc/1/stat: ok (313)
> procreads: /proc/2/stat: ok (149)
> procreads: /proc/3/stat: read size mismatch 313/150
> procreads: /proc/4/stat: read size mismatch 149/154
> procreads: /proc/5/stat: read size mismatch 150/161
> procreads: /proc/6/stat: read size mismatch 154/171
> ...
> 
> Any ideas?

Didn't look at your code yet, but with the current tree, this is the
behavior when a fixed file is used:

At prep time, if the slot is valid it is used. If it isn't valid,
assignment is deferred until the request is issued.

Which granted is a bit weird. It means that if you do:

<open fileA into slot 1, slot 1 currently unused><read slot 1>

the read will read from fileA. But for:

<open fileB into slot 1, slot 1 is fileA currently><read slot 1>

since slot 1 is already valid at prep time for the read, the read will
be from fileA again.

Is this what you are seeing? It's definitely a bit confusing, and the
only reason why I didn't change it is because it could potentially break
applications. Don't think there's a high risk of that, however, so may
indeed be worth it to just bite the bullet and the assignment is
consistent (eg always done from the perspective of the previous
dependent request having completed).

Is this what you are seeing?

-- 
Jens Axboe

