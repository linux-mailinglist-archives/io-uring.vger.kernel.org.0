Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73CF195B2F
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2020 17:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgC0QfT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Mar 2020 12:35:19 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:38416 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgC0QfT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Mar 2020 12:35:19 -0400
Received: by mail-pl1-f176.google.com with SMTP id w3so3637906plz.5
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2020 09:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M46dTk9Mg6uNvDz6YoDBibNyJVywCM7jUyk+VGGER8o=;
        b=BT0wbHzN1WNFdsC1LC7Q+2uPsn/1mT27qfNf9tIzhPazaRwAX0nvuU9nElzr2A3YiU
         s5hljfZfd2Plu+OPr+aCLzV4NQIjD49St+kqUe13H4VtaGSLxkINDqaIp5+F/RxcaapA
         K2+W3yTJP6pG7mlBzOJ+13FwAm9/kwfX+OU+t4MVsMaJPHuu4/pCkHo63A9ExHNf++iI
         KW/Glfz3PIN0kZSd2wTqxvzReODJH3sXInJGIE/KSyjbU9d2QikDHdXItkdDLTUew5ND
         xjjQwB8ow1t2xezaHYHV0ymPEAY/SMOZVCurPo4uMPdZSx5SFGynaFmfMYfwEqkS2F9N
         2vBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M46dTk9Mg6uNvDz6YoDBibNyJVywCM7jUyk+VGGER8o=;
        b=pld7HcUqQMIJ6JBP62BFWA/YL607t8lR4BVhtPQMLKf19B7EzV2+5vUvNsqdbEEp7z
         H22MhsUWe9Acr3Jp5IN+ZJEqJgtriJ3JVuYl+4QQruhA6YIl/qrNH1k97cLW6ODlT+rB
         DEzgT1g/i4yOQO/cq177dzumT3lek7nUfWpOFEDvjPDnLjM4s/YMZMESxQV047eVS/Zb
         F7HSI2fRIeTetFAQzhy0VhJ+KdArdFmZAeJytxz5lmQBBuv5iQnDEXtdFDarXn/3v3iu
         1AhB05FkQzx45RZqkqw3dYC39JhOCAo5tOSPYBN9nYYvnuxv+8xseEbT/WMe5rPED5VS
         jgqg==
X-Gm-Message-State: ANhLgQ18nnyjChdXzNbamVUju3PpWHJTpw3TbDXnEkwRzwDXCf6teX7b
        4Gt28BcJd+cK5fmR/jIFTLfIdg==
X-Google-Smtp-Source: ADFU+vuuwSgDGRSN3uiiP4R9sduHGxu9uBRYL33K0XACdp//N0Eji+mN0Ko/WyhyHG3UrUowKn9Yrw==
X-Received: by 2002:a17:90a:cb87:: with SMTP id a7mr301218pju.80.1585326917792;
        Fri, 27 Mar 2020 09:35:17 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id n7sm4215857pgm.28.2020.03.27.09.35.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 09:35:16 -0700 (PDT)
Subject: Re: Polled I/O cannot find completions
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <471572cf-700c-ec60-5740-0282930c849e@oracle.com>
 <4098ab93-980e-7a17-31f7-9eaeb24a2a65@kernel.dk>
 <34a7c633-c390-1220-3c78-1215bd64819f@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d2f92d20-2eb0-e683-5011-e1c922dfcf71@kernel.dk>
Date:   Fri, 27 Mar 2020 10:35:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <34a7c633-c390-1220-3c78-1215bd64819f@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/27/20 10:31 AM, Bijan Mottahedeh wrote:
> Does io_uring though have to deal with BLK_QC_T_NONE at all?  Or are you 
> saying that it should never receive that result?
> That's one of the things I'm not clear about.

BLK_QC_T_* are block cookies, they are only valid in the block layer.
Only the poll handler called should have to deal with them, inside
their f_op->iopoll() handler. It's simply passed from the queue to
the poll side.

So no, io_uring shouldn't have to deal with them at all.

The problem, as I see it, is if the block layer returns BLK_QC_T_NONE
and the IO was actually queued and requires polling to be found. We'd
end up with IO timeouts for handling those requests, and that's not a
good thing...

>> On 3/26/20 8:57 PM, Bijan Mottahedeh wrote:
>>> I'm seeing poll threads hang as I increase the number of threads in
>>> polled fio tests.  I think this is because of polling on BLK_QC_T_NONE
>>> cookie, which will never succeed.
>>>
>>> A related problem however, is that the meaning of BLK_QC_T_NONE seems to
>>> be ambiguous.
>>>
>>> Specifically, the following cases return BLK_QC_T_NONE which I think
>>> would be problematic for polled io:
>>>
>>>
>>> generic_make_request()
>>> ...
>>>           if (current->bio_list) {
>>>                   bio_list_add(&current->bio_list[0], bio);
>>>                   goto out;
>>>           }
>>>
>>> In this case the request is delayed but should get a cookie eventually.
>>> How does the caller know what the right action is in this case for a
>>> polled request?  Polling would never succeed.
>>>
>>>
>>> __blk_mq_issue_directly()
>>> ...
>>>           case BLK_STS_RESOURCE:
>>>           case BLK_STS_DEV_RESOURCE:
>>>                   blk_mq_update_dispatch_busy(hctx, true);
>>>                   __blk_mq_requeue_request(rq);
>>>                   break;
>>>
>>> In this case, cookie is not updated and would keep its default
>>> BLK_QC_T_NONE value from blk_mq_make_request().  However, this request
>>> will eventually be reissued, so again, how would the caller poll for the
>>> completion of this request?
>>>
>>> blk_mq_try_issue_directly()
>>> ...
>>>           ret = __blk_mq_try_issue_directly(hctx, rq, cookie, false, true);
>>>           if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE)
>>>                   blk_mq_request_bypass_insert(rq, false, true);
>>>
>>> Am I missing something here?
>>>
>>> Incidentally, I don't see BLK_QC_T_EAGAIN used anywhere, should it be?

Pretty sure that's a leftover from when the attempts was made to pass
back -EAGAIN inline instead of through the bio end_io handler.


-- 
Jens Axboe

