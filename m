Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CCA38DCCD
	for <lists+io-uring@lfdr.de>; Sun, 23 May 2021 22:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhEWUJO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 May 2021 16:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhEWUJO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 May 2021 16:09:14 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E533C061574;
        Sun, 23 May 2021 13:07:46 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id n2so26429677wrm.0;
        Sun, 23 May 2021 13:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tggQNXprZ2KXMcjjAudcZ47jW995L9WF7pjIIOpjVVo=;
        b=gYzxcdGGsjSXGl3H4eyLnY/jFZHQqFtP44csh7My3pbTf+k8L0bIkRF89rL64E1TT8
         YYbIF3Dg38u55WdN2r/4JauWsDN0wlV1THrFf1nVt9B5Lyp/zT0RiiSFIFL16Qpvi22B
         VIiTrsMQFiqqXW0bfpQzp1aqpoWyPtKYsIRtMktAcjhbaNPEHwX+pQsvstqLaZqVPBFJ
         ubWRlh+5JId3DhqPY/Ru+zq+/Wb971KmOq931y5OrTn45miCVW7JYE3OYl5ByKIvQ+dn
         f34Fg82nus3l/J5oKKz2OwkqF7JZyYkjcZosUCLB6M5Ol9h40jF9hIvel6zOTLuewCgT
         zAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tggQNXprZ2KXMcjjAudcZ47jW995L9WF7pjIIOpjVVo=;
        b=Z5KNvJBJ4AKpJgYhZetJk4H8wBAYJp7/2jZDsaK9otdM1x8AKCCYqImKaK3N1yks7v
         G+HgysQGClxvylwaHPZ5bDH1paJHQA8IDMrNIMwLD7cS166lbDUfb62L8eyf9QVW+mRv
         oDBB8Fiev+UBdQnT67UDtfOjM5KAxcSuZX4cSoVNJ7mvECXq4EltP6I4MCSJQhKokQrr
         aEKa7YlhRbuwLVD+TsWF4no9TOiTUY1m+0LvHSjSVL5o3PUlaYjnveCBSBrIZ2/M0Rwp
         QUecYkRp8UMHFVbvRbLu3EeLnineGdfh7xLtw3Ph9PGyriMCtqx0vGxBKfVFmcZ5mSbZ
         X3cg==
X-Gm-Message-State: AOAM531AOq7wLMSn9Hdq2dFFFhUvoduLEQsrIWs+NtCInBGMqzN8eeED
        b4/Goyv4Ajepop/lHTZwNB4=
X-Google-Smtp-Source: ABdhPJwzyOyx7608ZpbnjUcBc/K1/AGGqdEBZd5IQAv6YBdI2hQSpPj5aRF8fSG9NdjVcV0rITRqdA==
X-Received: by 2002:a05:6000:118c:: with SMTP id g12mr18727886wrx.320.1621800464833;
        Sun, 23 May 2021 13:07:44 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.65])
        by smtp.gmail.com with ESMTPSA id r17sm5889582wmh.25.2021.05.23.13.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 13:07:44 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogW3N5emJvdF0gS0FTQU46IHVzZS1hZnRlci1mcmVl?=
 =?UTF-8?Q?_Read_in_io=5fworker=5fhandle=5fwork?=
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     "Zhang, Qiang" <Qiang.Zhang@windriver.com>,
        syzbot <syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
References: <0000000000008224bf05c2a8a78b@google.com>
 <DM6PR11MB42024E7A188486B8850905D6FF299@DM6PR11MB4202.namprd11.prod.outlook.com>
 <b6a339b4-e25c-1466-3db4-f96739365ca6@gmail.com>
Message-ID: <7243f420-58c5-60e4-6c8f-c16a90766c0c@gmail.com>
Date:   Sun, 23 May 2021 21:07:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b6a339b4-e25c-1466-3db4-f96739365ca6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/22/21 1:55 AM, Pavel Begunkov wrote:
> On 5/21/21 9:45 AM, Zhang, Qiang wrote:
> [...]
>> It looks like 
>> thread iou-wrk-28796 in io-wq(A)  access wqe in the wait queue(data->hash->wait),  but this wqe  has been free due to the destruction of another io-wq(B).
>>
>> Should we after wait for all iou-wrk thread exit in the io-wq，  remove wqe from the waiting queue (data->hash->wait).   prevent some one  wqe  belonging to this io-wq , may be still existing in the (data->hash->wait)queue before releasing. 
> 
> The guess looks reasonable, it's likely a problem.
> Not sure about the diff, it seems racy but I need to
> take a closer look to say for sure

It looks sensible, please send a patch


>> look forward to your opinion.
>>
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -1003,13 +1003,17 @@ static void io_wq_exit_workers(struct io_wq *wq)
>>                 struct io_wqe *wqe = wq->wqes[node];
>>  
>>                 io_wq_for_each_worker(wqe, io_wq_worker_wake, NULL);
>> -               spin_lock_irq(&wq->hash->wait.lock);
>> -               list_del_init(&wq->wqes[node]->wait.entry);
>> -               spin_unlock_irq(&wq->hash->wait.lock);
>>         }
>>         rcu_read_unlock();
>>         io_worker_ref_put(wq);
>>         wait_for_completion(&wq->worker_done);
>> +       for_each_node(node) {
>> +               struct io_wqe *wqe = wq->wqes[node];
>> +
>> +               spin_lock_irq(&wq->hash->wait.lock);
>> +               list_del_init(&wq->wqes[node]->wait.entry);
>> +               spin_unlock_irq(&wq->hash->wait.lock);
>> +       }
>>         put_task_struct(wq->task);
>>         wq->task = NULL;
>>  }
> 

-- 
Pavel Begunkov
