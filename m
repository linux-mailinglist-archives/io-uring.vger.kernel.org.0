Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973C0195A01
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2020 16:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgC0PhE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Mar 2020 11:37:04 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:40692 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0PhE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Mar 2020 11:37:04 -0400
Received: by mail-pj1-f50.google.com with SMTP id kx8so3916481pjb.5
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2020 08:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7UBf1DuahhRtMwyxbslXC00LTHM9u0RyPfT7goTUM1o=;
        b=yQEMwBRR8a6ENWL/Nxn5lX35uzP2sdY9HQpCa3PSt4LQdCi9wDUPOUzt8dPxs8BZya
         lND/nQkNgNDPSkerouTSP9jf6IcCM3ODfeBcQsy90G/V01BMcvQePFeM3R4nrgIrtyog
         aDJ0AWR812A2fiLsrVjoyGcmWL1tzoLf6nkm3yAc3BdWeLQurGc+U/pGGsxg+QtQSFzo
         2Hf+g6gsOXjeeMf0nWOWHfj8G/qXr6h0gYF6Wk5wWsyKPtgBtEuoHHmz1SuO8RrjXiq4
         y8LdjmCj/Tj/WcOmwiJ5xIwU+OgcPXIoQdIal0RYhW2bRvhLv8nxHe08GgfMMjTu98rH
         DuKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7UBf1DuahhRtMwyxbslXC00LTHM9u0RyPfT7goTUM1o=;
        b=FHvy7DkZFdEYPNhN1ma01GrwoTjG+i3XF5MvDB3iZejJnlfGr821Ggg8T6JjpKCl80
         uW2a5t2AgxiazaI4OIDDgCQCb+nf8usrWXIHRs6wCAM4FwF5GurLAnkaLoFhyBQfdn+o
         e3HIKGIMUGG6+qn7ffNBv5CapmThV4fNkCOpNN/oLhSBDTn+sRhfrW9sDa4n2+KAHZwf
         P+zf6buNgemGEiFRK/bQ4lhm47H6H1UIpMe/thqP8b/5tW6mSz5vVzeP88IQAsNJsX1I
         Xm+rpU0R4chXhPWieVuLDuiIKOL2GNc2aazKrb4v3B0NNzrVvQ6vPjjBGUbvnMjGhMba
         LIEA==
X-Gm-Message-State: ANhLgQ03Z/kKMwZmVPw2I+oM1EqKb3AesD/RrFfMg03GI2it0LPg0EVj
        PFHu+I1e8uQ3mems5yovmgp/o6Fh6cXZyg==
X-Google-Smtp-Source: ADFU+vtTlT1tMguri7k0iWYzzoX+P2h37FmOYgMJUol9iUBYo8GCIgY+txKpM9u09LwQmPE6ZD91bA==
X-Received: by 2002:a17:902:7b97:: with SMTP id w23mr13635510pll.292.1585323422436;
        Fri, 27 Mar 2020 08:37:02 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id bx1sm4055963pjb.5.2020.03.27.08.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 08:37:01 -0700 (PDT)
Subject: Re: Polled I/O cannot find completions
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <471572cf-700c-ec60-5740-0282930c849e@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4098ab93-980e-7a17-31f7-9eaeb24a2a65@kernel.dk>
Date:   Fri, 27 Mar 2020 09:36:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <471572cf-700c-ec60-5740-0282930c849e@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CC'ing linux-block, this isn't an io_uring issue.


On 3/26/20 8:57 PM, Bijan Mottahedeh wrote:
> I'm seeing poll threads hang as I increase the number of threads in 
> polled fio tests.  I think this is because of polling on BLK_QC_T_NONE 
> cookie, which will never succeed.
> 
> A related problem however, is that the meaning of BLK_QC_T_NONE seems to 
> be ambiguous.
> 
> Specifically, the following cases return BLK_QC_T_NONE which I think 
> would be problematic for polled io:
> 
> 
> generic_make_request()
> ...
>          if (current->bio_list) {
>                  bio_list_add(&current->bio_list[0], bio);
>                  goto out;
>          }
> 
> In this case the request is delayed but should get a cookie eventually.  
> How does the caller know what the right action is in this case for a 
> polled request?  Polling would never succeed.
> 
> 
> __blk_mq_issue_directly()
> ...
>          case BLK_STS_RESOURCE:
>          case BLK_STS_DEV_RESOURCE:
>                  blk_mq_update_dispatch_busy(hctx, true);
>                  __blk_mq_requeue_request(rq);
>                  break;
> 
> In this case, cookie is not updated and would keep its default 
> BLK_QC_T_NONE value from blk_mq_make_request().  However, this request 
> will eventually be reissued, so again, how would the caller poll for the 
> completion of this request?
> 
> blk_mq_try_issue_directly()
> ...
>          ret = __blk_mq_try_issue_directly(hctx, rq, cookie, false, true);
>          if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE)
>                  blk_mq_request_bypass_insert(rq, false, true);
> 
> Am I missing something here?
> 
> Incidentally, I don't see BLK_QC_T_EAGAIN used anywhere, should it be?
> 
> Thanks.
> 
> --bijan
> 
> 
> 
> 


-- 
Jens Axboe

