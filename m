Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B2E1AD8CF
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2020 10:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgDQIkh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Apr 2020 04:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729746AbgDQIkg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Apr 2020 04:40:36 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436E3C061A0C
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 01:40:36 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o81so2071815wmo.2
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 01:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LewzYGGurhCAIPMIq9sDr/2UVUZDIVcHsRYQE+bQSik=;
        b=GWEg6JVtVHgSMWf4xISuCfZqTm7ygMGRYtLAkf3e+8Rpl2VasHDErFiEbGWC/IwGcW
         uZO5wpU24EYlMYbv7AFQr21ProoVmj/E6EBBhYZZ/oPFU/jZstsGUwOPf9xSlZK0nPtR
         PsWhiqEQA0/HfKfi3Tl1V6IfBycKKALXzNjsyGfOC7VqEYpodzjRgxyQNkjVCgVfheqi
         qDH6CvNhByz7AE5HLeAZjROuSD9Hqp8dLPJRYXTUxDAJn6yAwW3KZcIMEtrjiPOrN4Cc
         K3OAHj6f1eh9cSoj9gsxqRkRwpqP2Kh6vCFAMC0OiVgwNoC7OrcFytSIl+n4JmGrQ6O9
         O4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LewzYGGurhCAIPMIq9sDr/2UVUZDIVcHsRYQE+bQSik=;
        b=dXRb06miQYZ7Ozb7IAYNJjST3m+wSdWN6T58+CnWqGUF1J9bYxauKty8xUU4U5LfXz
         6d3ojhHf+sJL064oH2DC7EoNjt1ZttJirEMwwVqPN4fAE0yIZrn4weP+dQ07idO4hioM
         QN4hLX4U63mLpgQ6/FIbl9XksMuJXTe9obNVRwQkRlIcsy4ld82JAgBgCuxzIDKWxnpq
         yRxbalBIeyhLxkUkDk5WdZoGOFAwxIltJddGyw95/MWh608iayJ5QDn4qArCxQrOyubb
         Bua4V9E7q6ND2pn62Q+vp5rjJmU7kD6Nh1DUhJDJWPhla4paxYnf1PvkB1fxks44Zj05
         GH2w==
X-Gm-Message-State: AGi0PuaQyNdM7TPrBlml91VNbrePqzr8wyxewbipiGh1f7tqwoScd4uu
        3ZG2hoO6arO51Kj1K6zb+ZM=
X-Google-Smtp-Source: APiQypIR8sllRT3A0dIO2Y96yk4enVvAfBBqJh+Y8I1hgC+OUIi/ahg3teCGGV0C7Pz2gqRxMd2MpA==
X-Received: by 2002:a1c:64c5:: with SMTP id y188mr2172872wmb.130.1587112834838;
        Fri, 17 Apr 2020 01:40:34 -0700 (PDT)
Received: from [192.168.43.185] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id r17sm20301871wrn.43.2020.04.17.01.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 01:40:34 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Hrvoje Zeba <zeba.hrvoje@gmail.com>,
        io-uring@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>
References: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
 <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk>
 <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
 <969e4361-aae9-f713-c3b6-c79107352871@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Odd timeout behavior
Message-ID: <22e7a41d-389d-a4a9-14ae-c443668232a6@gmail.com>
Date:   Fri, 17 Apr 2020 11:39:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <969e4361-aae9-f713-c3b6-c79107352871@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/04/2020 17:40, Jens Axboe wrote:
>> On 4/12/2020 5:07 AM, Jens Axboe wrote:
>>> Thinking about this, I think the mistake here is using the SQ side for
>>> the timeouts. Let's say you queue up N requests that are waiting, like
>>> the poll. Then you arm a timeout, it'll now be at N + count before it
>>> fires. We really should be using the CQ side for the timeouts.
...
> Reason I bring up the other part is that Hrvoje's test case had other
> cases as well, and the SQ vs CQ trigger is worth looking into. For
> example, if we do:
> 
> enqueue N polls
> enqueue timeout, count == 2, t = 10s
> enqueue 2 nops
> 
> I'd logically expect the timeout to trigger when nop #2 is completed.
> But it won't be, because we still have N polls waiting. What the count
> == 2 is really saying (right now) is "trigger timeout when CQ passes SQ
> by 2", which seems a bit odd.
> 

time for this:

1. do we really want to change current behaviour? As you said, there may be users.

2. why a timeout can't be triggered by another timeout completion? There are
bits adjusting req->sequence for enqueued timeouts up and down. I understand,
that liburing hides timeouts from users, but handling them inconsistently in
that sense from any other request is IMHO a bad idea. Can we kill it?

3. For your case, should it to fire exactly after those 2 nops? Or it can be
triggered by previously completed requests (e.g. polls)?

e.g. timeline as follows
- enqueue polls
- enqueue timeout
- 2 polls completed
- the timeout triggered by completion of polls
- do nops

The second one is what io_uring pdf says, and I'd prefer to have it.

-- 
Pavel Begunkov
