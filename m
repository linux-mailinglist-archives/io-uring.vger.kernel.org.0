Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADDA6CAE6F
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 21:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjC0TU5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 15:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbjC0TU4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 15:20:56 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FEFE9
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 12:20:55 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-752fe6c6d5fso5702839f.1
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 12:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679944855;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LCCYMbSy55SlwvrGQG2ZZNlIg3a22xRlxaCQn9Xlyx4=;
        b=oaIXnvoPk7LwgHUucg2ww1TKYFdO5Sb3csY/DxK65O4ojHkknu8iu77a82RnapXc0q
         rw62wbU+CZ5wBNmBHpQXdx5P4+OFtlaSUbZbTAtUB/3yv1K/tE80Bf1qDHdh+SopUqUV
         DkBtvy3U3EJi2U0Mw8sJunSu2UMLMwAUdy+6LUQb4F7+iWGuEwjA5nXzdD0Y6M8WJDTm
         1bxGu1OHW9wnjo3j9jExDJaP/UDFerOwD/+Ml/av6oV1uaLM9NtJ1WMkdg9EBGt+JQrZ
         lo8mvlnjWShSPG+dVtFaIEeA1iwyetVqOiA2bcdDbL7AOKhjFDx/nG1GkqNjJ1IVrgBK
         VCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679944855;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LCCYMbSy55SlwvrGQG2ZZNlIg3a22xRlxaCQn9Xlyx4=;
        b=NHiiicjQ8QBT0EZvDGdmua7jR8TLUGy/bUFyOti1vSOwhgiFmjsyjmjZ/xEjqb6xit
         vh3t2SIicvy6Ow+zphckcFEFolsXHfIVGqXLjKC3O/CScJ3rumMFwyIflGxdGbjeKhK1
         oLHKJMANuiycCqgLUdEigJziKOuXSPVAsmayylnnQZJiigTJ63q6wnTHvrK1ngK9d23J
         ZGbUw5DymQ7Isr/zRnHS1N4kqG7pN9Qc35eGdKy3vSzNYmd4JJN0afEDDayRewPPI277
         3zb+xhZMLFStQqnrfu0/0V/yy704XQmSecaIgeNaq86ERne2osy9AvarBWrzcG+TmlLE
         6HFg==
X-Gm-Message-State: AAQBX9fgd+9ruoR9P6L/md6eDBqckokIdogrB/73sHpTTfIPvN4OManF
        Dwj0dVIYdQqQBsGEgb5AT8YhtQ==
X-Google-Smtp-Source: AKy350YZi2bmBiDeI8udzp9YCII8IAnUzjNzDDmzbG+jmPPRtaFTx6qhePyXwPc3hB/RAQw/5saf3Q==
X-Received: by 2002:a05:6e02:214a:b0:325:fab5:6e6e with SMTP id d10-20020a056e02214a00b00325fab56e6emr3971048ilv.1.1679944854893;
        Mon, 27 Mar 2023 12:20:54 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q12-20020a05663810cc00b003e8a17d7b1fsm9381018jad.27.2023.03.27.12.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 12:20:54 -0700 (PDT)
Message-ID: <75a684d6-8aca-8438-d303-f900b4db865d@kernel.dk>
Date:   Mon, 27 Mar 2023 13:20:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [syzbot] Monthly io-uring report
Content-Language: en-US
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     syzbot <syzbot+lista29bb0eabb2ddbae6f4a@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000bb028805f7dfab35@google.com>
 <2309ca53-a126-881f-1ffa-4f5415a32173@kernel.dk>
 <CANp29Y66H4-+d4hat_HCJck=u8dTn9Hw5KNzm1aYifQArQNNEw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANp29Y66H4-+d4hat_HCJck=u8dTn9Hw5KNzm1aYifQArQNNEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/27/23 1:12?PM, Aleksandr Nogikh wrote:
> On Mon, Mar 27, 2023 at 8:23?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/27/23 5:01?AM, syzbot wrote:
>>> 1873    Yes   WARNING in split_huge_page_to_list (2)
>>>               https://syzkaller.appspot.com/bug?extid=07a218429c8d19b1fb25
>>> 38      Yes   KASAN: use-after-free Read in nfc_llcp_find_local
>>>               https://syzkaller.appspot.com/bug?extid=e7ac69e6a5d806180b40
>>
>> These two are not io_uring. Particularly for the latter, I think syzbot
>> has a tendency to guess it's io_uring if any kind of task_work is
>> involved. That means anything off fput ends up in that bucket. Can we
>> get that improved please?
> 
> Sure, I'll update the rules and rerun the subsystem recognition.
> 
> Currently syzbot sets io_uring if at least one is true
> a) The crash stack trace points to the io_uring sources (according to
> MAINTAINERS)
> b) At least one reproducer has the syz_io_uring_setup call (that's a
> helper function that's part of syzkaller).
> 
> In general syzbot tries to minimize the reproducer, but unfortunately
> sometimes there remain some calls, which are not necessary per se. It
> definitely tried to get rid of them, but the reproducer was just not
> working with those calls cut out. Maybe they were just somehow
> affecting the global state and in the execution log there didn't exist
> any other call candidates, which could have fulfilled the purpose just
> as well.
> 
> I can update b) to "all reproducers have syz_io_uring_setup". Then
> those two bugs won't match the criteria.
> If it doesn't suffice and there are still too many false positives, I
> can drop b) completely.

Whatever cuts down on the noise is good with me. Not sure how 38 above
got lumped in? Maybe someone else did syz_io_uring_setup at some point?

> By the way, should F: fs/io-wq.c also be added to the IO_URING's
> record in the MAINTAINERS file?

I think you're looking at a really old tree, none of the supported
stable trees even have any io_uring code in fs/ anymore. Maybe they need
a MAINTAINERS update though? But even 5.10-stable has io-wq included,
though it's pointing at the wrong path now...

-- 
Jens Axboe

