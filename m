Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000D8440228
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 20:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhJ2SmA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 14:42:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37131 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229489AbhJ2Sl7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 14:41:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635532770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hikIcz0N/07Q9TN+8DIl5LsL8Jc1pDq37jWTcXTDQrk=;
        b=D9L3lVDMElZoIcbKwepOceEEzVIXrErywQmhPFQLkEngQrMUSZ+y2cG/tY2BRFWtJDt1LG
        WN64Re9fAMLE9CJbrR2L3jvigkx2s6DBVu7bLoKRYqESRThhV0OKcPVIzl9zYjbalN7e5L
        JD5yGjL6fM0JlDbT/UZZh6Tk2QcUtcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-IaosXERRONuhfWiR2sJ2Qg-1; Fri, 29 Oct 2021 14:39:28 -0400
X-MC-Unique: IaosXERRONuhfWiR2sJ2Qg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6946C18125CD
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 18:39:27 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.9.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F38D60E1C;
        Fri, 29 Oct 2021 18:39:11 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH v3 2/7] add support for the uring filter list
Date:   Fri, 29 Oct 2021 14:39:11 -0400
Message-ID: <2523658.Lt9SDvczpP@x2>
Organization: Red Hat
In-Reply-To: <20211028195939.3102767-3-rgb@redhat.com>
References: <20211028195939.3102767-1-rgb@redhat.com> <20211028195939.3102767-3-rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thursday, October 28, 2021 3:59:34 PM EDT Richard Guy Briggs wrote:
> Kernel support to audit io_uring operations filtering was added with
> commit 67daf270cebc ("audit: add filtering for io_uring records").  Add
> support for the "uring" filter list to auditctl.

Might have been good to show what the resulting auditctl command looks like. 
I think it would be:

auditctl -a always,io_ring  -U  open -F uid!=0 -F key=io_ring

But I wonder, why the choice of  -U rather than -S? That would make 
remembering the syntax easier.

auditctl -a always,io_ring  -S  open -F uid!=0 -F key=io_ring


> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  docs/audit.rules.7         |  19 ++++--
>  docs/audit_add_rule_data.3 |   4 ++
>  docs/auditctl.8            |  10 ++-
>  lib/flagtab.h              |  11 ++--
>  lib/libaudit.c             |  50 ++++++++++++---
>  lib/libaudit.h             |   7 +++
>  lib/lookup_table.c         |  20 ++++++
>  lib/private.h              |   1 +
>  src/auditctl-listing.c     |  52 ++++++++++------
>  src/auditctl.c             | 121 ++++++++++++++++++++++++++++++++-----
>  10 files changed, 240 insertions(+), 55 deletions(-)


<snip a whole lot of documentation> 


> diff --git a/lib/libaudit.c b/lib/libaudit.c
> index 54e276156ef0..3790444f4497 100644
> --- a/lib/libaudit.c
> +++ b/lib/libaudit.c
> @@ -86,6 +86,7 @@ static const struct nv_list failure_actions[] =
>  int _audit_permadded = 0;
>  int _audit_archadded = 0;
>  int _audit_syscalladded = 0;
> +int _audit_uringopadded = 0;
>  int _audit_exeadded = 0;
>  int _audit_filterfsadded = 0;
>  unsigned int _audit_elf = 0U;
> @@ -999,6 +1000,26 @@ int audit_rule_syscallbyname_data(struct
> audit_rule_data *rule, return -1;
>  }
> 
> +int audit_rule_uringopbyname_data(struct audit_rule_data *rule,
> +                                  const char *uringop)
> +{
> +	int nr, i;
> +
> +	if (!strcmp(uringop, "all")) {
> +		for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
> +			rule->mask[i] = ~0;
> +		return 0;
> +	}
> +	nr = audit_name_to_uringop(uringop);
> +	if (nr < 0) {
> +		if (isdigit(uringop[0]))
> +			nr = strtol(uringop, NULL, 0);
> +	}
> +	if (nr >= 0)
> +		return audit_rule_syscall_data(rule, nr);
> +	return -1;
> +}
> +
>  int audit_rule_interfield_comp_data(struct audit_rule_data **rulep,
>  					 const char *pair,
>  					 int flags)
> @@ -1044,7 +1065,7 @@ int audit_rule_interfield_comp_data(struct
> audit_rule_data **rulep, return -EAU_COMPVALUNKNOWN;
> 
>  	/* Interfield comparison can only be in exit filter */
> -	if (flags != AUDIT_FILTER_EXIT)
> +	if (flags != AUDIT_FILTER_EXIT && flags != AUDIT_FILTER_URING_EXIT)
>  		return -EAU_EXITONLY;
> 
>  	// It should always be AUDIT_FIELD_COMPARE
> @@ -1557,7 +1578,8 @@ int audit_rule_fieldpair_data(struct audit_rule_data
> **rulep, const char *pair, }
>  			break;
>  		case AUDIT_EXIT:
> -			if (flags != AUDIT_FILTER_EXIT)
> +			if (flags != AUDIT_FILTER_EXIT &&
> +			    flags != AUDIT_FILTER_URING_EXIT)
>  				return -EAU_EXITONLY;
>  			vlen = strlen(v);
>  			if (isdigit((char)*(v)))
> @@ -1599,7 +1621,8 @@ int audit_rule_fieldpair_data(struct audit_rule_data
> **rulep, const char *pair, case AUDIT_DIR:
>  			/* Watch & object filtering is invalid on anything
>  			 * but exit */
> -			if (flags != AUDIT_FILTER_EXIT)
> +			if (flags != AUDIT_FILTER_EXIT &&
> +			    flags != AUDIT_FILTER_URING_EXIT)
>  				return -EAU_EXITONLY;
>  			if (field == AUDIT_WATCH || field == AUDIT_DIR)
>  				_audit_permadded = 1;
> @@ -1621,9 +1644,11 @@ int audit_rule_fieldpair_data(struct audit_rule_data
> **rulep, const char *pair, _audit_exeadded = 1;
>  			}
>  			if (field == AUDIT_FILTERKEY &&
> -				!(_audit_syscalladded || _audit_permadded ||
> -				_audit_exeadded ||
> -				_audit_filterfsadded))
> +				!(_audit_syscalladded ||
> +				  _audit_uringopadded ||
> +				  _audit_permadded ||
> +				  _audit_exeadded ||
> +				  _audit_filterfsadded))
>                                  return -EAU_KEYDEP;
>  			vlen = strlen(v);
>  			if (field == AUDIT_FILTERKEY &&
> @@ -1712,7 +1737,8 @@ int audit_rule_fieldpair_data(struct audit_rule_data
> **rulep, const char *pair, }
>  			break;
>  		case AUDIT_FILETYPE:
> -			if (!(flags == AUDIT_FILTER_EXIT))
> +			if (!(flags == AUDIT_FILTER_EXIT ||
> +			      flags == AUDIT_FILTER_URING_EXIT))
>  				return -EAU_EXITONLY;
>  			rule->values[rule->field_count] =
>  				audit_name_to_ftype(v);
> @@ -1754,7 +1780,8 @@ int audit_rule_fieldpair_data(struct audit_rule_data
> **rulep, const char *pair, return -EAU_FIELDNOSUPPORT;
>  			if (flags != AUDIT_FILTER_EXCLUDE &&
>  			    flags != AUDIT_FILTER_USER &&
> -			    flags != AUDIT_FILTER_EXIT)
> +			    flags != AUDIT_FILTER_EXIT &&
> +			    flags != AUDIT_FILTER_URING_EXIT)

This is in the session_id code. Looking at the example audit event:

https://listman.redhat.com/archives/linux-audit/2021-September/msg00058.html

session_id is not in the record.


>  				return -EAU_FIELDNOFILTER;
>  			// Do positive & negative separate for 32 bit systems
>  			vlen = strlen(v);
> @@ -1775,7 +1802,8 @@ int audit_rule_fieldpair_data(struct audit_rule_data
> **rulep, const char *pair, break;
>  		case AUDIT_DEVMAJOR...AUDIT_INODE:

^^^ Can you audit by devmajor, devminor, or inode in io_ring?

>  		case AUDIT_SUCCESS:
> -			if (flags != AUDIT_FILTER_EXIT)
> +			if (flags != AUDIT_FILTER_EXIT &&
> +			    flags != AUDIT_FILTER_URING_EXIT)
>  				return -EAU_EXITONLY;
>  			/* fallthrough */
>  		default:
> @@ -1785,7 +1813,9 @@ int audit_rule_fieldpair_data(struct audit_rule_data
> **rulep, const char *pair, return -EAU_OPEQNOTEQ;
>  			}
> 
> -			if (field == AUDIT_PPID && !(flags==AUDIT_FILTER_EXIT))
> +			if (field == AUDIT_PPID &&
> +			    !(flags == AUDIT_FILTER_EXIT ||
> +			      flags == AUDIT_FILTER_URING_EXIT))
>  				return -EAU_EXITONLY;
> 
>  			if (!isdigit((char)*(v)))
> diff --git a/lib/libaudit.h b/lib/libaudit.h
> index 08b7d22678aa..a73edc677df0 100644
> --- a/lib/libaudit.h
> +++ b/lib/libaudit.h
> @@ -341,6 +341,9 @@ extern "C" {
>  #ifndef AUDIT_FILTER_EXCLUDE
>  #define AUDIT_FILTER_EXCLUDE	AUDIT_FILTER_TYPE
>  #endif
> +#ifndef AUDIT_FILTER_URING_EXIT
> +#define AUDIT_FILTER_URING_EXIT	0x07 /* filter on exit from io_uring op 
*/
> +#endif
>  #define AUDIT_FILTER_MASK	0x07	/* Mask to get actual filter */
>  #define AUDIT_FILTER_UNSET	0x80	/* This value means filter is unset */
> 
> @@ -612,6 +615,8 @@ extern int        audit_name_to_field(const char
> *field); extern const char *audit_field_to_name(int field);
>  extern int        audit_name_to_syscall(const char *sc, int machine);
>  extern const char *audit_syscall_to_name(int sc, int machine);
> +extern int        audit_name_to_uringop(const char *uringopop);
> +extern const char *audit_uringop_to_name(int uringop);
>  extern int        audit_name_to_flag(const char *flag);
>  extern const char *audit_flag_to_name(int flag);
>  extern int        audit_name_to_action(const char *action);
> @@ -706,6 +711,8 @@ extern struct audit_rule_data
> *audit_rule_create_data(void); extern void audit_rule_init_data(struct
> audit_rule_data *rule);
>  extern int audit_rule_syscallbyname_data(struct audit_rule_data *rule,
>                                            const char *scall);
> +extern int audit_rule_uringopbyname_data(struct audit_rule_data *rule,
> +                                          const char *uringop);
>  /* Note that the following function takes a **, where
> audit_rule_fieldpair() * takes just a *.  That structure may need to be
> reallocated as a result of * adding new fields */
> diff --git a/lib/lookup_table.c b/lib/lookup_table.c
> index 23678a4d142e..ca619fba930d 100644
> --- a/lib/lookup_table.c
> +++ b/lib/lookup_table.c
> @@ -142,6 +142,18 @@ int audit_name_to_syscall(const char *sc, int machine)
> return -1;
>  }
> 
> +int audit_name_to_uringop(const char *uringop)
> +{
> +	int res = -1, found = 0;
> +
> +#ifndef NO_TABLES
> +	//found = uringop_s2i(uringop, &res);

Why are we creating commented out function calls? It seems like this belongs 
in another patch and not here. But let's save everyone some iterations and 
overlook that.


Review complete...

-Steve



> +#endif
> +	if (found)
> +		return res;
> +	return -1;
> +}
> +
>  const char *audit_syscall_to_name(int sc, int machine)
>  {
>  #ifndef NO_TABLES
> @@ -172,6 +184,14 @@ const char *audit_syscall_to_name(int sc, int machine)
> return NULL;
>  }
> 
> +const char *audit_uringop_to_name(int uringop)
> +{
> +#ifndef NO_TABLES
> +	//return uringop_i2s(uringop);
> +#endif
> +	return NULL;
> +}
> +
>  int audit_name_to_flag(const char *flag)
>  {
>  	int res;
> diff --git a/lib/private.h b/lib/private.h
> index c3a7364fcfb8..b0d3fa4109c5 100644
> --- a/lib/private.h
> +++ b/lib/private.h
> @@ -135,6 +135,7 @@ AUDIT_HIDDEN_END
>  extern int _audit_permadded;
>  extern int _audit_archadded;
>  extern int _audit_syscalladded;
> +extern int _audit_uringopadded;
>  extern int _audit_exeadded;
>  extern int _audit_filterfsadded;
>  extern unsigned int _audit_elf;
> diff --git a/src/auditctl-listing.c b/src/auditctl-listing.c
> index a5d6bc2b046f..3d80906ffd24 100644
> --- a/src/auditctl-listing.c
> +++ b/src/auditctl-listing.c
> @@ -137,15 +137,22 @@ static int print_syscall(const struct audit_rule_data
> *r, unsigned int *sc) int all = 1;
>  	unsigned int i;
>  	int machine = audit_detect_machine();
> -
> -	/* Rules on the following filters do not take a syscall */
> -	if (((r->flags & AUDIT_FILTER_MASK) == AUDIT_FILTER_USER) ||
> -	    ((r->flags & AUDIT_FILTER_MASK) == AUDIT_FILTER_TASK) ||
> -	    ((r->flags &AUDIT_FILTER_MASK) == AUDIT_FILTER_EXCLUDE) ||
> -	    ((r->flags &AUDIT_FILTER_MASK) == AUDIT_FILTER_FS))
> +	int uring = 0;
> +
> +	/* Rules on the following filters do not take a syscall (or uringop) 
*/
> +	switch (r->flags & AUDIT_FILTER_MASK) {
> +	case AUDIT_FILTER_USER:
> +	case AUDIT_FILTER_TASK:
> +	case AUDIT_FILTER_EXCLUDE:
> +	case AUDIT_FILTER_FS:
>  		return 0;
> +		break;
> +	case AUDIT_FILTER_URING_EXIT:
> +		uring = 1;
> +		break;
> +	}
> 
> -	/* See if its all or specific syscalls */
> +	/* See if its all or specific syscalls/uringops */
>  	for (i = 0; i < (AUDIT_BITMASK_SIZE-1); i++) {
>  		if (r->mask[i] != (uint32_t)~0) {
>  			all = 0;
> @@ -154,21 +161,32 @@ static int print_syscall(const struct audit_rule_data
> *r, unsigned int *sc) }
> 
>  	if (all) {
> -		printf(" -S all");
> +		if (uring)
> +			printf(" -U all");
> +		else
> +			printf(" -S all");
>  		count = i;
>  	} else for (i = 0; i < AUDIT_BITMASK_SIZE * 32; i++) {
>  		int word = AUDIT_WORD(i);
>  		int bit  = AUDIT_BIT(i);
>  		if (r->mask[word] & bit) {
>  			const char *ptr;
> -			if (_audit_elf)
> -				machine = audit_elf_to_machine(_audit_elf);
> -			if (machine < 0)
> -				ptr = NULL;
> -			else
> -				ptr = audit_syscall_to_name(i, machine);
> +
> +			if (uring)
> +				ptr = audit_uringop_to_name(i);
> +			else {
> +				if (_audit_elf)
> +					machine = 
audit_elf_to_machine(_audit_elf);
> +				if (machine < 0)
> +					ptr = NULL;
> +				else
> +					ptr = audit_syscall_to_name(i, machine);
> +			}
>  			if (!count)
> -				printf(" -S ");
> +				if (uring)
> +					printf(" -U ");
> +				else
> +					printf(" -S ");
>  			if (ptr)
>  				printf("%s%s", !count ? "" : ",", ptr);
>  			else
> @@ -297,7 +315,7 @@ static void print_rule(const struct audit_rule_data *r)
> int mach = -1, watch = is_watch(r);
>  	unsigned long long a0 = 0, a1 = 0;
> 
> -	if (!watch) { /* This is syscall auditing */
> +	if (!watch) { /* This is syscall or uring auditing */
>  		printf("-a %s,%s",
>  			audit_action_to_name((int)r->action),
>  				audit_flag_to_name(r->flags));
> @@ -310,7 +328,7 @@ static void print_rule(const struct audit_rule_data *r)
> mach = print_arch(r->values[i], op);
>  			}
>  		}
> -		// And last do the syscalls
> +		// And last do the syscalls/uringops
>  		count = print_syscall(r, &sc);
>  	}
> 
> diff --git a/src/auditctl.c b/src/auditctl.c
> index f9bfc2a247d2..74df4f17f887 100644
> --- a/src/auditctl.c
> +++ b/src/auditctl.c
> @@ -76,6 +76,7 @@ static int reset_vars(void)
>  {
>  	list_requested = 0;
>  	_audit_syscalladded = 0;
> +	_audit_uringopadded = 0;
>  	_audit_permadded = 0;
>  	_audit_archadded = 0;
>  	_audit_exeadded = 0;
> @@ -110,7 +111,7 @@ static void usage(void)
>       "    -C f=f                            Compare collected fields if
> available:\n" "                                      Field name,
> operator(=,!=), field name\n" "    -d <l,a>                         
> Delete rule from <l>ist with <a>ction\n" -     "                          
>            l=task,exit,user,exclude,filesystem\n" +     "                 
>                     l=task,exit,user,exclude,filesystem,uring\n" "        
>                              a=never,always\n"
>       "    -D                                Delete all rules and
> watches\n" "    -e [0..2]                         Set enabled flag\n"
> @@ -132,6 +133,7 @@ static void usage(void)
>       "    -S syscall                        Build rule: syscall name or
> number\n" "    --signal <signal>                 Send the specified signal
> to the daemon\n" "    -t                                Trim directory
> watches\n" +     "    -U uringop                        Build rule: uring
> op name or number\n" "    -v                                Version\n"
>       "    -w <path>                         Insert watch at <path>\n"
>       "    -W <path>                         Remove watch at <path>\n"
> @@ -164,6 +166,8 @@ static int lookup_filter(const char *str, int *filter)
>  		exclude = 1;
>  	} else if (strcmp(str, "filesystem") == 0)
>  		*filter = AUDIT_FILTER_FS;
> +	else if (strcmp(str, "uring") == 0)
> +		*filter = AUDIT_FILTER_URING_EXIT;
>  	else
>  		return 2;
>  	return 0;
> @@ -541,6 +545,36 @@ static int parse_syscall(const char *optarg)
>  	return audit_rule_syscallbyname_data(rule_new, optarg);
>  }
> 
> +static int parse_uringop(const char *optarg)
> +{
> +	int retval = 0;
> +	char *saved;
> +
> +	if (strchr(optarg, ',')) {
> +		char *ptr, *tmp = strdup(optarg);
> +		if (tmp == NULL)
> +			return -1;
> +		ptr = strtok_r(tmp, ",", &saved);
> +		while (ptr) {
> +			retval = audit_rule_uringopbyname_data(rule_new, ptr);
> +			if (retval != 0) {
> +				if (retval == -1) {
> +					audit_msg(LOG_ERR,
> +						"Uring op name unknown: %s",
> +						ptr);
> +					retval = -3; // error reported
> +				}
> +				break;
> +			}
> +			ptr = strtok_r(NULL, ",", &saved);
> +		}
> +		free(tmp);
> +		return retval;
> +	}
> +
> +	return audit_rule_uringopbyname_data(rule_new, optarg);
> +}
> +
>  static struct option long_opts[] =
>  {
>  #if HAVE_DECL_AUDIT_FEATURE_VERSION == 1
> @@ -576,7 +610,7 @@ static int setopt(int count, int lineno, char *vars[])
>      keylen = AUDIT_MAX_KEY_LEN;
> 
>      while ((retval >= 0) && (c = getopt_long(count, vars,
> -			"hicslDvtC:e:f:r:b:a:A:d:S:F:m:R:w:W:k:p:q:",
> +			"hicslDvtC:e:f:r:b:a:A:d:S:U:F:m:R:w:W:k:p:q:",
>  			long_opts, &lidx)) != EOF) {
>  	int flags = AUDIT_FILTER_UNSET;
>  	rc = 10;	// Init to something impossible to see if unused.
> @@ -715,9 +749,10 @@ static int setopt(int count, int lineno, char *vars[])
> retval = -1;
>  		break;
>          case 'a':
> -		if (strstr(optarg, "task") && _audit_syscalladded) {
> +		if (strstr(optarg, "task") && (_audit_syscalladded ||
> +					       _audit_uringopadded)) {
>  			audit_msg(LOG_ERR,
> -				"Syscall auditing requested for task list");
> +				"Syscall or uring op auditing requested for task 
list");
>  			retval = -1;
>  		} else {
>  			rc = audit_rule_setup(optarg, &add, &action);
> @@ -739,9 +774,10 @@ static int setopt(int count, int lineno, char *vars[])
> }
>  		break;
>          case 'A':
> -		if (strstr(optarg, "task") && _audit_syscalladded) {
> -			audit_msg(LOG_ERR,
> -			   "Error: syscall auditing requested for task list");
> +		if (strstr(optarg, "task") && (_audit_syscalladded ||
> +					       _audit_uringopadded)) {
> +			audit_msg(LOG_ERR,
> +				"Syscall or uring op auditing requested for task 
list");
>  			retval = -1;
>  		} else {
>  			rc = audit_rule_setup(optarg, &add, &action);
> @@ -809,6 +845,10 @@ static int setopt(int count, int lineno, char *vars[])
> audit_msg(LOG_ERR,
>  		    "Error: syscall auditing cannot be put on exclude list");
>  			return -1;
> +		} else if (((add | del) & AUDIT_FILTER_MASK) == 
AUDIT_FILTER_URING_EXIT)
> { +			audit_msg(LOG_ERR,
> +		    "Error: syscall auditing cannot be put on uringop list");
> +			return -1;
>  		} else {
>  			if (unknown_arch) {
>  				int machine;
> @@ -853,14 +893,63 @@ static int setopt(int count, int lineno, char
> *vars[]) break;
>  		}}
>  		break;
> +        case 'U':
> +		/* Do some checking to make sure that we are not adding a
> +		 * uring op rule to a list that does not make sense. */
> +		if (((add & (AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) ==
> +				AUDIT_FILTER_TASK || (del &
> +				(AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) ==
> +				AUDIT_FILTER_TASK)) {
> +			audit_msg(LOG_ERR,
> +			  "Error: uring op auditing being added to task list");
> +			return -1;
> +		} else if (((add & (AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) ==
> +				AUDIT_FILTER_USER || (del &
> +				(AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) ==
> +				AUDIT_FILTER_USER)) {
> +			audit_msg(LOG_ERR,
> +			  "Error: uring op auditing being added to user list");
> +			return -1;
> +		} else if (((add & (AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) ==
> +				AUDIT_FILTER_FS || (del &
> +				(AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) ==
> +				AUDIT_FILTER_FS)) {
> +			audit_msg(LOG_ERR,
> +			  "Error: uring op auditing being added to filesystem 
list");
> +			return -1;
> +		} else if (exclude) {
> +			audit_msg(LOG_ERR,
> +		    "Error: uring op auditing cannot be put on exclude list");
> +			return -1;
> +		} else if (((add | del) & AUDIT_FILTER_MASK) == 
AUDIT_FILTER_EXIT) {
> +			audit_msg(LOG_ERR,
> +		    "Error: uringop auditing cannot be put on syscall list");
> +			return -1;
> +		}
> +		rc = parse_uringop(optarg);
> +		switch (rc)
> +		{
> +			case 0:
> +				_audit_uringopadded = 1;
> +				break;
> +			case -1:
> +				audit_msg(LOG_ERR, "Uring op name unknown: %s",
> +							optarg);
> +				retval = -1;
> +				break;
> +			case -3: // Error reported - do nothing here
> +				retval = -1;
> +				break;
> +		}
> +		break;
>          case 'F':
>  		if (add != AUDIT_FILTER_UNSET)
>  			flags = add & AUDIT_FILTER_MASK;
>  		else if (del != AUDIT_FILTER_UNSET)
>  			flags = del & AUDIT_FILTER_MASK;
> -		// if the field is arch & there is a -t option...we
> +		// if the field is arch & there is a -t option...we
>  		// can allow it
> -		else if ((optind >= count) || (strstr(optarg, "arch=") == 
NULL)
> +		else if ((optind >= count) || (strstr(optarg, "arch=") == NULL 
&&
> _audit_uringopadded != 1)
>  				 || (strcmp(vars[optind], "-t") != 0)) {
> 
>  			audit_msg(LOG_ERR, "List must be given before field");
>  			retval = -1;
> @@ -989,12 +1078,12 @@ static int setopt(int count, int lineno, char
> *vars[]) }
>  		break;
>  	case 'k':
> -		if (!(_audit_syscalladded || _audit_permadded ||
> -		      _audit_exeadded ||
> +		if (!(_audit_syscalladded || _audit_uringopadded ||
> +		      _audit_permadded || _audit_exeadded ||
>  		      _audit_filterfsadded) ||
>  		    (add==AUDIT_FILTER_UNSET && del==AUDIT_FILTER_UNSET)) {
>  			audit_msg(LOG_ERR,
> -		    "key option needs a watch or syscall given prior to it");
> +		    "key option needs a watch, syscall or uring op given prior 
to it");
>  			retval = -1;
>  			break;
>  		} else if (!optarg) {
> @@ -1031,7 +1120,7 @@ process_keys:
>  			retval = audit_setup_perms(rule_new, optarg);
>  		break;
>          case 'q':
> -		if (_audit_syscalladded) {
> +		if (_audit_syscalladded || _audit_uringopadded) {
>  			audit_msg(LOG_ERR,
>  			   "Syscall auditing requested for make equivalent");
>  			retval = -1;
> @@ -1466,7 +1555,7 @@ int main(int argc, char *argv[])
>  static int handle_request(int status)
>  {
>  	if (status == 0) {
> -		if (_audit_syscalladded) {
> +		if (_audit_syscalladded || _audit_uringopadded) {
>  			audit_msg(LOG_ERR, "Error - no list specified");
>  			return -1;
>  		}
> @@ -1478,7 +1567,7 @@ static int handle_request(int status)
>  		if (add != AUDIT_FILTER_UNSET) {
>  			// if !task add syscall any if not specified
>  			if ((add & AUDIT_FILTER_MASK) != AUDIT_FILTER_TASK &&
> -					_audit_syscalladded != 1) {
> +					(_audit_syscalladded != 1 && 
_audit_uringopadded != 1)) {
>  					audit_rule_syscallbyname_data(
>  							rule_new, "all");
>  			}
> @@ -1502,7 +1591,7 @@ static int handle_request(int status)
>  		}
>  		else if (del != AUDIT_FILTER_UNSET) {
>  			if ((del & AUDIT_FILTER_MASK) != AUDIT_FILTER_TASK &&
> -					_audit_syscalladded != 1) {
> +					(_audit_syscalladded != 1 && 
_audit_uringopadded != 1)) {
>  					audit_rule_syscallbyname_data(
>  							rule_new, "all");
>  			}




