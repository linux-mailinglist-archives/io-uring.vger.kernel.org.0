Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CFC1740C7
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 21:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgB1UPQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 15:15:16 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44208 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1UPQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 15:15:16 -0500
Received: by mail-pf1-f195.google.com with SMTP id y5so2257062pfb.11
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 12:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zcCBLPTMOLEiaweLspv+BVLcuCaQqx+hfZZASz1/lU0=;
        b=sxkTmgFn64WH1R4LiPSYkVj5Rd/+r+hNLN9sTDKdBVTYXeoPZG0i8iZC7sxuc4nNhC
         KqP9X7SKmhvTNvFkKSgy7Hs2aom8Vi0R4o49Sj5C6WmGEfjioBcYPkEDMeWikuCrpeRj
         noyxXeaVqTC6oL5gAjD0YecgbHxpW31lkPowevNEWp9QAjf8X7eqhLEJYEQBtVHzKInp
         NAiehs273ha9i4sfWzGhF3S14KWROe6LOwCKfjXQcvKBF3AORzu0FwS191WqpRyLFts7
         n2z+uciZrSyZInbA4zODAM6h666ytV2nBBSYwvRuE6D7LvbAbA+cneIDgnRyz6MiWu+o
         YHmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zcCBLPTMOLEiaweLspv+BVLcuCaQqx+hfZZASz1/lU0=;
        b=aaBDsoX4e1wIv5PfcUD3Tc4rykO1/IUM9ZhObgyFOUSdQ+YYTNnuJanHctBBMs9yqB
         Wim3UHXauoFh7EqjuD8AU3QJ7bHmRgNFpz1OsHIugoe2031rylOL0LA5OgM7Glc8FlSy
         V/eABiek5aOL6K6hQWwfvqLNlMXR3yIezyoXjI5ZKVg8kWHoOvWpgv+dftgYYcJN41y+
         bwnpoVupB54UBxgD4oPm5gvEY9fZOPfUCezf/egRY4ovEIFvejzN5CHtEuzp9Qbl8e4t
         pgvWlH1jya6onpR6+apKfgj8WB3JQtwIJu5G6qF27rSJj3xcSoj8zVJGR0Sb6cW2JNTE
         p/xg==
X-Gm-Message-State: ANhLgQ06sjIOEpc4Cb/dof7AjQ9rxMWQtoBNyKOEEzsmYapOGiyzlc6i
        Rl1s6JwPDJOmV5wIgcptTZPqRkjX1h4=
X-Google-Smtp-Source: ADFU+vs3hRJK8rVZtacTGbT5b0e6kUFyZuqvH9bGZGEMT0BckDAuU/xmAhH1GXthDUyo3TFYZSYKlg==
X-Received: by 2002:a62:ae13:: with SMTP id q19mr2324371pff.244.1582920913730;
        Fri, 28 Feb 2020 12:15:13 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21d6::12c6? ([2620:10d:c090:400::5:410c])
        by smtp.gmail.com with ESMTPSA id u7sm11780035pfh.128.2020.02.28.12.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 12:15:13 -0800 (PST)
Subject: Re: [PATCH] task_work_run: don't take ->pi_lock unconditionally
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <20200218150756.GC14914@hirez.programming.kicks-ass.net>
 <20200218155017.GD3466@redhat.com>
 <20200220163938.GA18400@hirez.programming.kicks-ass.net>
 <20200220172201.GC27143@redhat.com>
 <20200220174932.GB18400@hirez.programming.kicks-ass.net>
 <20200221145256.GA16646@redhat.com>
 <77349a8d-ecbf-088d-3a48-321f68f1774f@kernel.dk>
 <de55c2ac-bc94-14d8-68b1-b2a9c0cb7428@kernel.dk>
 <20200228192505.GO18400@hirez.programming.kicks-ass.net>
 <4c320163-cb3b-8070-4441-6395c988d55d@kernel.dk>
 <20200228200653.GP11457@worktop.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4c14e794-d967-dbc4-2718-2562cf9a7077@kernel.dk>
Date:   Fri, 28 Feb 2020 13:15:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200228200653.GP11457@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/28/20 1:06 PM, Peter Zijlstra wrote:
> On Fri, Feb 28, 2020 at 12:28:54PM -0700, Jens Axboe wrote:
> 
>> Shelf the one I have queued up, or the suggested changes that you had
>> for on top of it?
> 
> The stuff on top.

OK all good, thanks for confirming.

-- 
Jens Axboe

