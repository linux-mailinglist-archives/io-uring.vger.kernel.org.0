Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC1B287537
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 15:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbgJHNYv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 09:24:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbgJHNYv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 09:24:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602163490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Udupsb/n1o2VfYDaX1x29f+NgYQ2LOLwGNy4Q7PY2E=;
        b=LxXmFLlsx96Y1yjScf3rcwtqNNtVWXstwnWDNsrs5b8Wxxo8cv5w85ayP/KlKzS0puMCkX
        Wqx/VYaO99Zmo9ayZutFGMA0Ukuh8eysjL+cVVwVUWfQP3Ps4vp9F8dqwYtjpXTpPCFb6f
        mn3XL91wuaKMKkHsCv2dc023KvxG27E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-ctcnHB4eNPWFuYNpHtqVPw-1; Thu, 08 Oct 2020 09:24:48 -0400
X-MC-Unique: ctcnHB4eNPWFuYNpHtqVPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26F03425D1;
        Thu,  8 Oct 2020 13:24:47 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.132])
        by smtp.corp.redhat.com (Postfix) with SMTP id B24B360BFA;
        Thu,  8 Oct 2020 13:24:45 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  8 Oct 2020 15:24:46 +0200 (CEST)
Date:   Thu, 8 Oct 2020 15:24:44 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 2/6] kernel: add task_sigpending() helper
Message-ID: <20201008132444.GF9995@redhat.com>
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201005150438.6628-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005150438.6628-3-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/05, Jens Axboe wrote:
>
> @@ -4447,7 +4447,7 @@ SYSCALL_DEFINE0(pause)
>  		__set_current_state(TASK_INTERRUPTIBLE);
>  		schedule();
>  	}
> -	return -ERESTARTNOHAND;
> +	return task_sigpending(current) ? -ERESTARTNOHAND : -ERESTARTSYS;
>  }
>
>  #endif
> @@ -4462,7 +4462,7 @@ static int sigsuspend(sigset_t *set)
>  		schedule();
>  	}
>  	set_restore_sigmask();
> -	return -ERESTARTNOHAND;
> +	return task_sigpending(current) ? -ERESTARTNOHAND : -ERESTARTSYS;
>  }

Both changes are equally wrong. Why do you think sigsuspend() should ever
return -ERESTARTSYS ?

If get_signal() deques a signal, handle_signal() will restart this syscall
if ERESTARTSYS, this is wrong.

Oleg.

